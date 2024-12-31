module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class FamilyDoctor < Rendering::Base
          pattr_initialize [:patient!]

          def xml
            family_doctor_element
          end

          private

          def family_doctor_element
            create_node("FamilyDoctor") do |family_doctor|
              if patient.practice.present?
                family_doctor << create_node("GPPracticeId", patient.practice.code)
              end
              if patient.primary_care_physician.present?
                family_doctor << create_node("GPId", patient.primary_care_physician.code)
              end
            end
          end
        end
      end
    end
  end
end
