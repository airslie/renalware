module Renalware
  module Pathology
    module Requests
      class PatientRule < ApplicationRecord
        include FrequencyMethods

        self.table_name = "pathology_requests_patient_rules"

        belongs_to :patient, class_name: "::Renalware::Pathology::Patient"
        belongs_to :lab, class_name: "::Renalware::Pathology::Lab"
        has_and_belongs_to_many :requests,
                                class_name: "::Renalware::Pathology::Requests::Request"

        validates :lab, presence: true
        validates :test_description, presence: true
        validates :patient_id, presence: true

        OBSERVATION_REQUIRED = true
        OBSERVATION_NOT_REQUIRED = false

        def self.policy_class = BasePolicy

        def required?(date)
          return OBSERVATION_NOT_REQUIRED unless today_within_range?(date)
          return OBSERVATION_REQUIRED if last_observed_at.nil?

          days_ago_observed = date - last_observed_at.to_date

          frequency.observation_required?(days_ago_observed)
        end

        def last_observed_at
          last_request = patient.last_request_for_patient_rule(self)
          return if last_request.nil?

          last_request.created_at
        end

        private

        def today_within_range?(today)
          return OBSERVATION_REQUIRED unless start_date.present? && end_date.present?

          if today.between?(start_date.to_date, end_date.to_date)
            OBSERVATION_REQUIRED
          else
            OBSERVATION_NOT_REQUIRED
          end
        end
      end
    end
  end
end
