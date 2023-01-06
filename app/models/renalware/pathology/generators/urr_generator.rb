# frozen_string_literal: true

module Renalware
  module Pathology
    module Generators
      # Generate missing urr pathology_observations.
      # Used when the labs does not provide these. We call a SQL fn which
      # finds post-HD Urea results and looks 'around' that time to find the corresponsing pre-HD
      # Urea. The pre Urea might have arrived before or slightly after the post-HD one. The number
      # of hours to look ahead and behind is configurable.
      class UrrGenerator
        def self.call
          new.call
        end

        def call
          results = execute_sql_fn
          results.each do |result|
            create_urr_observation_under_same_obr_as_post_urea(result.with_indifferent_access)
          end
        end

        private

        def execute_sql_fn
          ActiveRecord::Base.connection.execute(<<-SQL.squish)
            select * from renalware.pathology_missing_urrs(
              #{hours_to_search_behind_for_pre_ure_result},
              #{hours_to_search_ahead_for_pre_ure_result},
              '#{post_hd_ure_code}',
              '#{pre_hd_ure_code}'
            );
          SQL
        end

        class ResultRow
          pattr_initialize :result

          def urr_value
            return 0 unless pre_ure && post_ure

            (((pre_ure - post_ure) / pre_ure) * 100).round(2)
          end

          def request_id
            result[:post_urea_request_id]
          end

          def observed_at
            result[:post_urea_observed_at]
          end

          def pre_ure
            result[:pre_urea_result]
          end

          def post_ure
            result[:post_urea_result]
          end
        end

        def create_urr_observation_under_same_obr_as_post_urea(result)
          row = ResultRow.new(result)
          if row.urr_value > 0
            Rails.logger.info("Creating URR in OBR #{row.request_id}")
            Observation.create!(
              description: urr_description,
              request_id: row.request_id,
              observed_at: row.observed_at,
              result: row.urr_value
            )
          end
        end

        def hours_to_search_behind_for_pre_ure_result
          Renalware.config.pathology_hours_to_search_behind_for_pre_ure_result
        end

        def hours_to_search_ahead_for_pre_ure_result
          Renalware.config.pathology_hours_to_search_ahead_for_pre_ure_result
        end

        def post_hd_ure_code
          Renalware.config.pathology_post_hd_urea_code
        end

        def pre_hd_ure_code
          "URE"
        end

        def urr_description
          @urr_description ||= ObservationDescription.find_by(code: "URR")
        end
      end
    end
  end
end
