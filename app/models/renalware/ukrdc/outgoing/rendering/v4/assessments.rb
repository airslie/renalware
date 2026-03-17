# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        module V4
          class Assessments < Rendering::Base
            pattr_initialize [:patient!]

            def xml
              assessments_element
            end

            # Value object to represent an assessment for the purposes of rendering UKRDC XML.
            # This is not intended to be persisted.
            class Data
              rattr_initialize [:start_date!, :end_date!, :outcome_code!]
            end

            private

            def assessments_element
              create_node("Assessments") do |assessments_elem|
                assessments.each do |assessment|
                  assessments_elem << assessment.xml
                end
              end
            end

            # UKRDC Assessments map to several different models in Renalware
            # Type: 'TPLTassess' (Suitability for renal transplant) => Renalware workups
            # Type: RRTassess (Shared future RRT choice) => Renalware Care Plan Assessments
            # PPDassess (Preferred place of dying) => Renalware Demographics death place preference
            def assessments
              @assessments ||= begin
                [
                  *transplant_registration_assessments,
                  akcc_assessment,
                  preferred_death_location
                ].compact
              end
            end

            def preferred_death_location
              outcome = patient.preferred_death_location&.ukrdc_assessment_outcome
              if outcome.present?
                Assessment.new(outcome:)
              end
            end

            def akcc_assessment
              dialysis_plan = patient.becomes(LowClearance::Patient).profile&.dialysis_plan
              outcome = dialysis_plan&.ukrdc_assessment_outcome
              if dialysis_plan.present? && outcome.present?
                Assessment.new(
                  outcome:,
                  start_date: dialysis_plan.created_at.to_date
                )
              end
            end

            def transplant_registration_assessments
              patient.becomes(Transplants::Patient).registrations.map do |registration|
                registration.statuses.order(started_on: :asc).filter_map do |status|
                  outcome = status.description.ukrdc_assessment_outcome
                  Assessment.new(outcome:, start_date: status&.started_on) if outcome.present?
                end
              end.flatten
            end
          end
        end
      end
    end
  end
end
