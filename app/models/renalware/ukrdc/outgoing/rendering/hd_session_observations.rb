# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class HDSessionObservations < Rendering::Observation
          pattr_initialize [:session!]

          def create_observation_nodes_under(parent_element)
            pre_and_post_observations.each do |pre_or_post, observations|
              measurements_for(observations).each do |i18n_key, value|
                parent_element << Rendering::Observation.new(
                  observed_at: observation_times[pre_or_post].iso8601,
                  measurement: value.to_s[0, 19].strip,
                  i18n_key: i18n_key,
                  pre_post: pre_or_post.to_s.upcase # eg PRE or POST
                ).xml
              end
            end
          end

          def observation_times
            @observation_times ||= begin
              performed_on = session.performed_on.to_datetime
              {
                pre: performed_on + session.start_time.seconds_since_midnight.seconds,
                post: performed_on + session.end_time.seconds_since_midnight.seconds
              }
            end
          end

          def pre_and_post_observations
            {
              pre: session.document.observations_before,
              post: session.document.observations_after
            }
          end

          def measurements_for(observations)
            {
              "blood_pressure.systolic" => observations.blood_pressure&.systolic,
              "blood_pressure.diastolic" => observations.blood_pressure&.diastolic,
              "weight" => coerce_to_float(observations.weight)
            }
          end
        end
      end
    end
  end
end
