require "duration_calculator"

module Renalware
  module HD
    class Session < ApplicationRecord
      include PatientScope
      include Accountable
      include ExplicitStateModel
      include TransactionRetry
      include RansackAll

      acts_as_paranoid

      # Prevent instances of this of this base class from being saved
      validates :type, presence: true

      has_states :open, :closed, :dna

      belongs_to :patient, touch: true
      belongs_to :provider, class_name: "HD::Provider"
      belongs_to :profile
      belongs_to :station, foreign_key: "hd_station_id"
      belongs_to :dry_weight, class_name: "Renalware::Clinical::DryWeight"
      belongs_to :modality_description, class_name: "Modalities::Description"
      belongs_to :hospital_unit, class_name: "Hospitals::Unit"
      belongs_to :dialysate
      belongs_to :signed_on_by, class_name: "User"
      belongs_to :signed_off_by, class_name: "User"
      has_many :session_patient_group_directions, dependent: :destroy, inverse_of: :session
      has_many :patient_group_directions,
               through: :session_patient_group_directions,
               class_name: "Drugs::PatientGroupDirection"
      has_many :prescription_administrations,
               class_name: "PrescriptionAdministration",
               foreign_key: "hd_session_id",
               dependent: :destroy
      accepts_nested_attributes_for :prescription_administrations
      accepts_nested_attributes_for :session_patient_group_directions

      has_paper_trail(
        versions: { class_name: "Renalware::HD::Version" },
        on: [:create, :update, :destroy]
      )

      before_save :compute_duration
      before_create :assign_modality

      scope :ordered, -> { order(started_at: :desc) }

      validates :patient, presence: true
      validates :hospital_unit, presence: true
      validates :signed_on_by, presence: true
      validates :started_at, presence: true, timeliness: { type: :datetime }
      validates :stopped_at, timeliness: { type: :datetime, allow_blank: true }

      delegate :hospital_centre, to: :hospital_unit, allow_nil: true

      # Virtual attr for the form object used to capture start and end of the session
      attribute :duration_form

      # Ensure notes saved with trix editor are marked html safe
      def notes = attributes["notes"]&.html_safe # rubocop:disable Rails/OutputSafety

      def compute_duration
        return unless started_at_changed? || stopped_at_changed?

        self.duration = DurationCalculator.in_minutes(started_at, stopped_at)
      end

      def assign_modality
        self.modality_description = patient.modality_description
      end

      def started_at_date
        started_at&.to_date
      end

      def performed_on
        started_at_date
      end

      def start_time
        started_at&.strftime("%H:%M")
      end

      def end_time
        stopped_at&.strftime("%H:%M")
      end
    end
  end
end
