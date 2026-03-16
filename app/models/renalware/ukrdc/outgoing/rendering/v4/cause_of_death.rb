# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        module V4
          class CauseOfDeath < Rendering::Base
            pattr_initialize [:cause!, diagnosis_type!: "PRIMARY"]

            def xml
              cause_of_death_element
            end

            private

            def cause_of_death_element
              cause_code = cause.code
              cause_code = 99 if cause_code == 34

              create_node("CauseOfDeath") do |elem|
                elem << create_node("DiagnosisType", diagnosis_type)
                elem << create_node("Diagnosis") do |diagnosis_element|
                  diagnosis_element << create_node("CodingStandard", "EDTA_COD")
                  diagnosis_element << create_node("Code", cause_code)
                end
                elem << create_node("EnteredOn", cause.created_at.to_datetime)
              end
            end
          end
        end
      end
    end
  end
end
