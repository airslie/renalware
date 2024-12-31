module Renalware
  module Pathology
    module Charts
      module Chartable
        extend ActiveSupport::Concern

        def chart_series_json(patient_id:, start_date:)
          sql = ChartFunctionSqlBuilder.new(
            patient_id: patient_id,
            start_date: start_date
          ).to_sql(self)

          {
            name: code,
            color: chart_colour,
            axis_type: axis_type,
            data: execute_chart_sql_fn_and_return_json(sql)
          }
        end

        def axis_label
          measurement_unit&.name
        end

        def execute_chart_sql_fn_and_return_json(sql)
          ActiveRecord::Base.connection.execute(Arel.sql(sql)).values.as_json
        end

        def axis_type
          chart_logarithmic ? "logarithmic" : "linear"
        end

        # Eg "CRP 'C-Reactive Protein'"
        def title
          parts = [code, name].compact_blank.uniq
          case parts.length
          when 2 then "#{parts[0]} (#{parts[1]})"
          when 1 then parts.first
          else ""
          end
        end

        class ChartFunctionSqlBuilder
          pattr_initialize [:patient_id!, :start_date!]

          def to_sql(chartable)
            if chartable.chart_sql_function_name.present?
              <<-SQL.squish
                select * from
                #{chartable.chart_sql_function_name}(
                  #{patient_id},
                  '#{start_date}'::date
                )
              SQL
            else
              <<-SQL.squish
                select * from
                renalware.pathology_chart_series(
                  #{patient_id},
                  #{chartable.id},
                  '#{start_date}'::date
                )
              SQL
            end
          end
        end
      end
    end
  end
end
