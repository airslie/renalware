# frozen_string_literal: true

module Renalware
  module Medications
    class Prescription < ApplicationRecord
      include Accountable
      include RansackAll
      extend Enumerize

      attr_accessor :drug_id_and_trade_family_id

      has_paper_trail(
        versions: { class_name: "Renalware::Medications::PrescriptionVersion" },
        on: [:create, :update]
      )

      belongs_to :patient, touch: true

      # A drug can be soft-deleted (its deleted_at set) so that it can no longer be prescribed.
      # We need to be sure we can still display deleted drugs in the read-only context of an
      # existing prescription, so we include deleted drugs in the relationship.
      belongs_to :drug, -> { with_deleted }, class_name: "Renalware::Drugs::Drug"
      belongs_to :treatable, polymorphic: true
      belongs_to :medication_route
      belongs_to :unit_of_measure, optional: true, class_name: "Renalware::Drugs::UnitOfMeasure"
      belongs_to :trade_family, optional: true, class_name: "Renalware::Drugs::TradeFamily"
      belongs_to :form, optional: true, class_name: "Renalware::Drugs::Form"

      has_one :termination,
              class_name: "PrescriptionTermination",
              dependent: :delete,
              inverse_of: :prescription

      accepts_nested_attributes_for :termination,
                                    update_only: true,
                                    reject_if: ->(attributes) { attributes["terminated_on"].blank? }

      delegate :terminated_on, to: :termination, allow_nil: true
      delegate :name, to: :drug, prefix: true, allow_nil: true

      validates :patient, presence: true
      validates :treatable_id, presence: true
      validates :treatable_type, presence: true
      validates :drug, presence: true
      validates :dose_amount, presence: true
      validates :medication_route, presence: true
      validates :frequency, presence: true
      validates :prescribed_on, presence: true
      validates :provider, presence: true

      enum :provider, Provider.codes

      # deprecated, use `unit_of_measure` instead
      enumerize :dose_unit,
                in: DoseUnit.codes,
                i18n_scope: "enumerize.renalware.medications.prescription.dose_unit"

      scope :ordered, lambda {
        joins(:drug).order("drugs.name asc, prescribed_on desc, created_at desc")
      }
      scope :with_medication_route, -> { includes(:medication_route) }
      scope :with_forms, -> { includes(:form) }
      scope :with_drugs, -> { includes(drug: :drug_types).includes(:trade_family) }
      scope :with_classifications, -> { includes(drug: :drug_type_classifications) }
      scope :with_termination, -> { includes(termination: [:created_by]) }
      scope :with_units_of_measure, -> { includes(:unit_of_measure) }
      scope :current, lambda { |date = Date.current|
        left_outer_joins(:termination)
          .where("terminated_on IS NULL OR terminated_on > ?", date)
      }
      scope :terminated, lambda { |date = Date.current|
        joins(:termination).where(termination: { terminated_on: ..date })
      }
      scope :to_be_administered_on_hd, lambda {
        current
          .where(administer_on_hd: true)
          .where(prescribed_on: ..Time.zone.today)
      }
      scope :having_drug_of_type, lambda { |drug_type_name|
        where("lower(drug_types.code) = lower(?)", drug_type_name)
      }
      scope :to_be_administered_on_hd_and_starting_before, lambda { |date|
        current
          .where(administer_on_hd: true)
          .where(prescribed_on: ..date)
      }
      # Prescriptions created or changed since 14 days ago (and potentially into
      # the future). Because editing a prescription terminates it and creates a new one,
      # we are essentially searching on prescribed_on date here.
      scope :recently_changed, -> { where(prescribed_on: 14.days.ago..) }
      scope :current_non_hd, -> { current.where.not(administer_on_hd: true) }
      scope :current_hd, -> { current.where(administer_on_hd: true) }
      scope :recently_changed_current, -> { current.recently_changed }

      # Find non-current prescriptions terminated within 14 days
      scope :recently_stopped, lambda {
        terminated
          .terminated_between(from: 14.days.ago, to: ::Time.zone.now)
          .where.not(drug_id: current.map(&:drug_id))
      }

      # This is a Ransack-compatible search predicate
      def self.default_search_order
        ["drug_name asc", "prescribed_on desc"]
      end

      def self.created_between(from:, to:)
        where("medication_prescriptions.created_at >= ? and " \
              "medication_prescriptions.created_at <= ?", from, to)
      end

      def self.prescribed_between(from:, to:)
        where("medication_prescriptions.prescribed_on >= ? and " \
              "medication_prescriptions.prescribed_on <= ?", from, to)
      end

      def self.terminated_between(from:, to:)
        where("terminated_on >= ? and terminated_on <= ?", from, to)
      end

      # @section attributes
      #
      def terminated_by
        return unless terminated_or_marked_for_termination?

        termination.created_by
      end

      # @section predicates
      #

      def current?(date = Date.current)
        terminated_on.nil? || terminated_on >= date
      end

      def terminated_or_marked_for_termination?
        terminated_on.present?
      end

      # @section services
      #

      def terminate(by:, terminated_on: Date.current)
        build_termination(by: by, terminated_on: terminated_on)
      end

      def drug_name
        trade_family.present? ? "#{drug.name} (#{trade_family.name})" : drug.name
      end
    end
  end
end
