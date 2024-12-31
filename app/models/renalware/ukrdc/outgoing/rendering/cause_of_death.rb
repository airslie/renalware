module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class CauseOfDeath < Rendering::Base
          pattr_initialize [:patient!]
          delegate :first_cause, to: :patient, allow_nil: true

          def xml
            return nil unless patient.dead? && first_cause.present?

            cause_of_death_element
          end

          private

          def cause_of_death_element
            cause_code = first_cause.code
            cause_code = 99 if cause_code == 34

            create_node("CauseOfDeath") do |elem|
              elem << create_node("DiagnosisType", "final")
              elem << create_node("Diagnosis") do |diagnosis_element|
                diagnosis_element << create_node("CodingStandard", "EDTA_COD")
                diagnosis_element << create_node("Code", cause_code)
              end
              elem << create_node("EnteredOn", first_cause.created_at.to_datetime)
            end
          end
        end
      end
    end
  end
end
