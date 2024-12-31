# require "renalware/automatic_age_calculator"

module Renalware
  module Transplants
    class RecipientOperation < ApplicationRecord
      include Document::Base
      include PatientScope
      extend Enumerize

      belongs_to :patient, touch: true
      belongs_to :hospital_centre, class_name: "Hospitals::Centre"
      belongs_to :induction_agent
      has_one :followup,
              class_name: "RecipientFollowup",
              foreign_key: "operation_id",
              dependent: :restrict_with_exception

      scope :ordered, -> { order(performed_on: :asc) }
      scope :reversed, -> { order(performed_on: :desc) }
      scope :most_recent, -> { order(performed_on: :desc).first }

      has_paper_trail(
        versions: { class_name: "Renalware::Transplants::Version" },
        on: [:create, :update, :destroy]
      )

      has_document class_name: "Renalware::Transplants::RecipientOperationDocument"

      validates :performed_on, presence: true
      validates :operation_type, presence: true
      validates :hospital_centre, presence: true

      validates :donor_kidney_removed_from_ice_at,
                timeliness: { type: :datetime },
                allow_blank: true
      validates :kidney_perfused_with_blood_at,
                timeliness: { type: :datetime },
                allow_blank: true
      validates :theatre_case_start_time,
                timeliness: { type: :time },
                allow_blank: true

      enumerize :operation_type,
                in: %i(kidney kidney_dual kidney_pancreas kidney_other pancreas kidney_liver liver)

      enumerize :immunological_risk, in: %i(low intermediate high ABOi)

      def theatre_case_start_time
        TimeOfDay.new(self[:theatre_case_start_time])
      end

      def cold_ischaemic_time_formatted
        # For presentation purposes
        Duration.new(self[:cold_ischaemic_time]).to_s
      end

      def cold_ischaemic_time_formatted=(value)
        self.cold_ischaemic_time = Duration.from_string(value).seconds
      end

      def warm_ischaemic_time_formatted
        # For presentation purposes
        Duration.new(self[:warm_ischaemic_time]).to_s
      end

      def warm_ischaemic_time_formatted=(value)
        self.warm_ischaemic_time = Duration.from_string(value).seconds
      end

      def recipient_age_at_operation
        @recipient_age_at_operation ||=
          AutomaticAgeCalculator.new(
            Age.new,
            born_on: patient.born_on, age_on_date: performed_on
          ).compute
      end
    end
  end
end
