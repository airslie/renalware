module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class RenalDiagnosis < Rendering::Base
          pattr_initialize [:patient!]

          def xml
            return if patient.prd_description_code.blank?

            renal_diagnosis_element
          end

          private

          # The nested Diagnosis is correct.
          def renal_diagnosis_element
            elem = Rendering::Diagnosis.new(
              coding_standard: "EDTA2",
              code: patient.prd_description_code,
              description: patient.prd_description_term,
              root_element_name: "RenalDiagnosis"
            )
            if patient.first_seen_on.present?
              elem.identification_time = patient.first_seen_on
            end
            elem.xml
          end
        end
      end
    end
  end
end
