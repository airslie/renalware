# frozen_string_literal: true

module Renalware
  module Letters
    class Letter < ApplicationRecord
      include Accountable
      include TransactionRetry
      extend Enumerize
      include RansackAll

      acts_as_paranoid

      # The letterhead is the only site-specific element in the letter, so we use this
      # to determine site-specific settings - in this case whether the letter should contain
      # pathology. At KCH for example, Darren Valley letters should not contain recent pathology.
      delegate :include_pathology_in_letter_body?, to: :letterhead, allow_nil: true

      belongs_to :event, polymorphic: true
      belongs_to :author, class_name: "User"
      belongs_to :submitted_for_approval_by, class_name: "User"
      belongs_to :approved_by, class_name: "User"
      belongs_to :completed_by, class_name: "User"
      belongs_to :deleted_by, class_name: "User"
      belongs_to :patient, touch: true
      belongs_to :letterhead
      belongs_to :topic, class_name: "Letters::Topic", optional: true
      has_one :main_recipient,
              -> { where(role: "main") },
              class_name: "Recipient",
              inverse_of: :letter
      has_many :cc_recipients,
               -> { where(role: "cc") },
               class_name: "Recipient",
               dependent: :destroy,
               inverse_of: :letter
      has_many :recipients, dependent: :destroy
      has_many :electronic_receipts, dependent: :destroy
      has_many :electronic_cc_recipients,
               through: :electronic_receipts,
               source: :recipient # recipient here is class User not Letters:Recipient
      has_many :section_snapshots, dependent: :destroy
      has_one :signature, dependent: :destroy
      has_one :archive, inverse_of: :letter
      has_many :qr_encoded_online_reference_links, dependent: :destroy
      has_many :online_reference_links, through: :qr_encoded_online_reference_links
      serialize :pathology_snapshot, coder: Pathology::ObservationsJsonbSerializer

      accepts_nested_attributes_for :main_recipient
      accepts_nested_attributes_for :cc_recipients, reject_if: :all_blank, allow_destroy: true

      validates :letterhead, presence: true
      validates :author, presence: true
      validates :patient, presence: true
      validates :topic, presence: true, if: ->(letter) { letter.description.nil? }

      validates :main_recipient, presence: true

      include ExplicitStateModel
      has_states :draft, :pending_review, :approved, :completed
      state_scope :reviewable, :pending_review

      scope :pending, lambda {
        where(type: [state_class_name(:draft), state_class_name(:pending_review)])
      }
      singleton_class.send(:alias_method, :in_progress, :pending)

      scope :reversed, -> { order(Arel.sql(effective_date_sort) => :asc) }
      scope :ordered, -> { order(Arel.sql(effective_date_sort) => :desc) }
      scope :with_letterhead, -> { includes(:letterhead) }
      scope :with_main_recipient, -> { includes(main_recipient: [:address, :addressee]) }
      scope :with_deleted_by, -> { includes(:deleted_by) }
      scope :with_author, -> { includes(:author) }
      scope :with_patient, -> { includes(patient: :primary_care_physician) }
      scope :with_event, -> { includes(:event) }
      scope :with_cc_recipients, -> { includes(cc_recipients: :addressee) }
      scope :approved_or_completed, lambda {
        where(type: [state_class_name(:approved), state_class_name(:completed)])
      }

      delegate :primary_care_physician, to: :patient
      delegate :visit_number, :clinic_code, to: :event, allow_nil: true
      delegate :sections, to: :topic, allow_nil: true

      EVENTS_MAP = {
        Clinics::ClinicVisit => Event::ClinicVisit,
        NilClass => Event::Unknown
      }.freeze

      enum :gp_send_status, {
        not_applicable: "not_applicable",
        pending: "pending",
        success: "success",
        failure: "failure"
      }, prefix: true

      def self.policy_class     = LetterPolicy
      def self.for_event(event) = where(event: event).first

      attribute :effective_date_sort

      def self.effective_date_sort
        Arel.sql(<<~SQL.squish)
          coalesce(
            completed_at,
            approved_at,
            submitted_for_approval_at,
            letter_letters.created_at
          )
        SQL
      end

      def effective_date_sort = self.class.effective_date_sort

      # A Letter Event is unrelated to Events::Event. Instead it is an un-persisted decorator
      # around the polymorphic event relationship (determined by event_class and event_id);
      # each concrete Event class decorates that relationship with some helpers, for example
      # #part_classes which determined which extra letter 'parts' should be rendered for that
      # specific polymorphic relationship. Note that general clinical parts_classes are defined
      # on Letter, because a relationship to say a ClinicVisit (the letter event) is not required
      # for a letter to want to have clinical content (prescriptions etc.). Clinical parts will
      # always be included if #clinical? is true. This for example enables us to create a
      # 'clinical letter' which is a simple letter with the added clinical parts, but which is
      # unrelated to a clinic_visit for instance.
      def letter_event
        EVENTS_MAP.fetch(event.class, Event::ClinicVisit).new(event, clinical: clinical?)
      end

      def find_cc_recipient_for_contact(contact)
        cc_recipients.detect { |recipient| recipient.for_contact?(contact) }
      end

      def determine_counterpart_ccs
        DetermineCounterpartCCs.new(self).call
      end

      def subject?(other_patient) = patient.id == other_patient.id
      def signed?                 = signature.present?
      def archived?               = archive.present?
      def archived_by             = archive.created_by
      def archive_recipients!     = recipients.each(&:archive!)

      def effective_date
        completed_at || approved_at || submitted_for_approval_at || created_at
      end

      # The date to display on the letter.
      # Once the letter is approved it can be emailed out, hence this is the real date of issue.
      def date = datetime.to_date
      def datetime = approved_at || submitted_for_approval_at || created_at

      class ExternalDocumentType
        rattr_initialize :code, :name
      end

      def external_document_type_code         = clinical? ? "CL" : "AL"
      def external_document_type_description  = clinical? ? "Clinic Letter" : "Adhoc Letter"

      # Can be used when exported to external sytems eg via HL7/Mirth.
      # id e.g. 123 => "RW0000000123"
      def external_id
        return if id.blank?

        ["RW", id.to_s.rjust(10, "0")].join
      end

      # Helper method to coerce a Letters::Letter instance into its STI type
      def to_typed_instance
        is_a?(type.constantize) ? self : becomes(type.constantize)
      end

      def gp_is_a_recipient?
        gp_recipient.present?
      end

      def gp_recipient
        recipients.find(&:primary_care_physician?)
      end
    end
  end
end
