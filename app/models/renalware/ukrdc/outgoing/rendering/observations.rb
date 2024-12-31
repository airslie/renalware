module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class Observations < Rendering::Base
          pattr_initialize [:patient!]

          def xml
            observations_element
          end

          private

          def observations_element
            create_node("Observations") do |observations_elem|
              observations_elem[:start] = patient.changes_since.to_date.iso8601
              observations_elem[:stop] = patient.changes_up_until.to_date.iso8601

              add_clinic_visit_observations_elements_to(observations_elem)
              add_hd_session_observations_elements_to(observations_elem)
            end
          end

          def add_clinic_visit_observations_elements_to(parent_elem)
            patient.clinic_visits.each do |visit|
              clinic_visit_methods_hash.each do |method, i18n_key|
                parent_elem << Rendering::ClinicVisitObservation.new(
                  visit: visit,
                  method: method,
                  i18n_key: i18n_key
                ).xml
              end
            end
          end

          def add_hd_session_observations_elements_to(parent_elem)
            patient.finished_hd_sessions.each do |session|
              HDSessionObservations
                .new(session: session)
                .create_observation_nodes_under(parent_elem)
            end
          end

          def clinic_visit_methods_hash
            {
              systolic_bp: "blood_pressure.systolic",
              diastolic_bp: "blood_pressure.diastolic",
              weight: "weight",
              height_in_cm: "height"
            }
          end
        end
      end
    end
  end
end
