module Renalware
  module Pathology
    module Requests
      class GlobalRule
        class LatestCRFOlderThanWeeks < GlobalRule
          validates :param_comparison_value, presence: true

          # Returns true if the patient has a transplant registration with a latest CRF date
          # older than <param_comparison_value> weeks ago.
          def observation_required_for_patient?(patient, date)
            registration = registration_for(patient)
            return false unless registration

            latest_crf_date = registration.document.crf.latest.recorded_on
            return false if latest_crf_date.blank?

            max_crf_date = date - param_comparison_value.to_i.weeks
            latest_crf_date < max_crf_date
          end

          def to_s
            "latest CRF older than #{param_comparison_value} weeks"
          end

          private

          def registration_for(patient)
            Transplants::Registration.for_patient(patient).first
          end
        end
      end
    end
  end
end
