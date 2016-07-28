require_dependency "renalware/medications"

module Renalware
  module Medications
    class Prescription < ActiveRecord::Base
      include Accountable
      extend Enumerize

      attr_accessor :drug_select

      has_paper_trail class_name: "Renalware::Medications::PrescriptionVersion"

      belongs_to :patient
      belongs_to :drug, class_name: "Renalware::Drugs::Drug"
      belongs_to :treatable, polymorphic: true
      belongs_to :medication_route

      has_one :termination, class_name: "PrescriptionTermination"
      accepts_nested_attributes_for :termination, update_only: true,
        reject_if: -> (attributes) { attributes['terminated_on'].blank? }
      delegate :terminated_on, to: :termination, allow_nil: true

      validates :patient, presence: true
      validates :treatable, presence: true
      validates :drug, presence: true
      validates :dose_amount, presence: true
      validates :dose_unit, presence: true
      validates :medication_route, presence: true
      validates :frequency, presence: true
      validates :prescribed_on, presence: true
      validates :provider, presence: true
      validate :constrain_route_description

      enum provider: Provider.codes

      enumerize :dose_unit, in: %i(
        ampoule
        capsule
        drop
        gram
        international_unit
        microgram
        milligram
        millilitre
        puff
        tab
        tablet
        unit
      ), i18n_scope: "enumerize.renalware.medications.prescription.dose_unit"

      scope :ordered, -> { order(default_search_order) }
      scope :current, -> (date = Date.current) {
        joins(<<-SQL)
          LEFT OUTER JOIN medication_prescription_terminations pt
            ON (medication_prescriptions.id = pt.prescription_id)
        SQL
          .where("terminated_on IS NULL OR terminated_on > ?", date)
      }
      scope :terminated, -> (date = Date.current) {
        joins(:termination)
          .where("terminated_on <= ?", date)
      }

      def self.default_search_order
        "prescribed_on desc"
      end

      def self.peritonitis
        self.new(treatable_type: "Renalware::PeritonitisEpisode")
      end

      def self.exit_site
        self.new(treatable_type: "Renalware::ExitSiteInfection")
      end

      def terminated_by
        return unless terminated?

        termination.created_by
      end

      def terminate(by:, terminated_on: Date.current)
        build_termination(by: by, terminated_on: terminated_on)
      end

      def current?(date=Date.current)
        self.terminated_on.nil? || self.terminated_on >= date
      end

      def terminated?
        self.terminated_on.present?
      end

      private

      def constrain_route_description
        return unless medication_route

        case
        when medication_route.other? && !route_description.present?
          errors.add(:route_description, :blank)
        when !medication_route.other? && route_description.present?
          errors.add(:route_description, :not_other)
        end
      end
    end
  end
end
