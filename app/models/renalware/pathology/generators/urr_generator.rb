module Renalware
  module Pathology
    module Generators
      # Generate missing urr pathology_observations and also a simple ktv.
      # Used when the lab does not provide these. We call a SQL fn which
      # finds post-HD Urea results and looks 'around' that time to find the corresponding pre-HD
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

        # Returns array of PG::Result
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
            return 0 unless pre_urea_result && post_urea_result

            (((pre_urea_result - post_urea_result) / pre_urea_result) * 100).round(2)
          end

          def method_missing(method_name, **_args, &)
            result[method_name.to_sym]
          end

          def respond_to_missing?(method_name, _include_private = false)
            result.key?(method_name.to_sym) || super
          end
        end

        def create_urr_observation_under_same_obr_as_post_urea(result)
          row = ResultRow.new(result)
          if row.urr_value > 0
            create_urr_observation(row)
            create_simple_ktv_observation(row)
          end
        end

        def create_urr_observation(row)
          observation = create_observation(row.urr_value, urr_description, row)
          create_calculation_sources(observation, row)
        end

        def create_observation(value, description, row)
          Observation.create!(
            description: description,
            request_id: row.post_urea_request_id,
            observed_at: row.post_urea_observed_at,
            result: value
          )
        end

        def create_simple_ktv_observation(row)
          # Create the simple kt/v that does not rely on on any HD session data
          simple_ktv = - Math.log(row.post_urea_result / row.pre_urea_result).round(2)
          observation = create_observation(simple_ktv, ktv_description, row)
          create_calculation_sources(observation, row)
        end

        # For visibility, debugging and later kt/v calculation, store the ids of the source
        # observations used to calculate an observation
        def create_calculation_sources(observation, row)
          [
            row.pre_urea_observation_id,
            row.post_urea_observation_id
          ].each do |obs_id|
            CalculationSource.create!(
              calculated_observation: observation,
              source_observation_id: obs_id
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

        def ktv_description
          @ktv_description ||= ObservationDescription.find_or_create_by(code: "Kt/V") do |record|
            record.name = "Simple non-dialysis Kt/V"
          end
        end
      end
    end
  end
end
