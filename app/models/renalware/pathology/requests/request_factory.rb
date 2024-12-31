module Renalware
  module Pathology
    module Requests
      class RequestFactory
        pattr_initialize :patient, :params

        def build
          Request.new(request_params)
        end

        private

        def request_params
          {
            patient: patient,
            clinic: params[:clinic],
            consultant: params[:consultant],
            telephone: params[:telephone],
            template: params[:template],
            request_descriptions: request_descriptions,
            patient_rules: patient_rules,
            high_risk: patient.high_risk?,
            by: params[:by]
          }
        end

        def request_descriptions
          patient.required_observation_requests(params[:clinic])
        end

        def patient_rules
          patient.required_patient_pathology
        end
      end
    end
  end
end
