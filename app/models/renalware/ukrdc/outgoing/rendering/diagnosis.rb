module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class Diagnosis < Rendering::Base
          pattr_initialize [
            :coding_standard!,
            :code!,
            :description!,
            :onset_time,
            :identification_time,
            root_element_name!: "Diagnosis"
          ]
          attr_accessor :onset_time, :identification_time

          def xml
            diagnosis_element
          end

          private

          # The nested Diagnosis is correct.
          def diagnosis_element
            create_node(root_element_name) do |elem|
              elem << create_node("Diagnosis") do |diagnosis_elem|
                diagnosis_elem << create_node("CodingStandard", coding_standard)
                diagnosis_elem << create_node("Code", code)
                diagnosis_elem << create_node("Description", description)
              end
              add_onset_time_element_to(elem)
              add_identification_time_element_to(elem)
            end
          end

          def add_onset_time_element_to(elem)
            return if onset_time.blank?

            elem << create_node("OnsetTime", onset_time)
          end

          def add_identification_time_element_to(elem)
            return if identification_time.blank?

            elem << create_node("IdentificationTime", identification_time)
          end
        end
      end
    end
  end
end
