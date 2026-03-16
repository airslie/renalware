# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        module V4
          class Assessment < Rendering::Base
            pattr_initialize [:outcome!, :start_date, :end_date]

            def xml = assessment_element

            private

            def assessment_element
              create_node("Assessment") do |elem|
                elem << start_element if start_date.present?
                elem << end_element if end_date.present?
                elem << type_element
                elem << outcome_element
              end
            end

            def start_element = create_node("AssessmentStart", start_date.to_datetime.iso8601)
            def end_element   = create_node("AssessmentEnd", end_date.to_datetime.iso8601)

            def type_element
              type = outcome.assessment_type
              create_node("AssessmentType") do |elem|
                elem << create_node("CodingStandard", "RR50")
                elem << create_node("Code", type.code)
                elem << create_node("Description", type.description)
              end
            end

            def outcome_element
              create_node("AssessmentOutcome") do |elem|
                elem << create_node("CodingStandard", "RR51")
                elem << create_node("Code", outcome.code)
                elem << create_node("Description", outcome.description)
              end
            end
          end
        end
      end
    end
  end
end
