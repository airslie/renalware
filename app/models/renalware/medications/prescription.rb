# frozen_string_literal: true

module Renalware
  module Medications
    class Prescription < ApplicationRecord
      include Accountable
      extend Enumerize

      attr_accessor :drug_select

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
      validates :treatable, presence: true
      validates :drug, presence: true
      validates :dose_amount, presence: true
      validates :dose_unit, presence: true
      validates :medication_route, presence: true
      validates :frequency, presence: true
      validates :prescribed_on, presence: true
      validates :provider, presence: true
      validate  :constrain_route_description

      enum provider: Provider.codes

      enumerize :dose_unit,
                in: DoseUnit.codes,
                i18n_scope: "enumerize.renalware.medications.prescription.dose_unit"

      scope :ordered, lambda {
        joins(:drug).order("drugs.name asc, prescribed_on desc")
      }
      scope :with_medication_route, -> { includes(:medication_route) }
      scope :with_drugs, -> { includes(drug: :drug_types) }
      scope :with_classifications, -> { includes(drug: :classifications) }
      scope :with_termination, -> { includes(termination: [:created_by]) }
      scope :current, lambda { |date = Date.current|
        left_outer_joins(:termination)
          .where("terminated_on IS NULL OR terminated_on > ?", date)
      }
      scope :terminated, lambda { |date = Date.current|
        joins(:termination)
          .where("terminated_on <= ?", date)
      }
      scope :to_be_administered_on_hd, -> { current.where(administer_on_hd: true) }
      scope :having_drug_of_type, lambda { |drug_type_name|
        where("lower(drug_types.code) = lower(?)", drug_type_name)
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

      private

      def constrain_route_description
        return unless medication_route

        route_description_present = route_description.present?
        route_other = medication_route.other?
        if route_other && !route_description_present
          errors.add(:route_description, :blank)
        elsif !route_other && route_description_present
          errors.add(:route_description, :not_other)
        end
      end
    end
  end
end
