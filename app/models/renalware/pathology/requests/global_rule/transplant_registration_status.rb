module Renalware
  module Pathology
    module Requests
      class GlobalRule
        class TransplantRegistrationStatus < GlobalRule
          validates :param_comparison_value, presence: true

          def observation_required_for_patient?(patient, _date)
            registration = Transplants::Registration.for_patient(patient).first
            return false if registration.blank?

            registration_status = registration.current_status
            return false if registration_status.blank?

            registration_status.description.code == param_comparison_value
          end

          def to_s
            "transplant registration status is #{param_comparison_value}"
          end
        end
      end
    end
  end
end
