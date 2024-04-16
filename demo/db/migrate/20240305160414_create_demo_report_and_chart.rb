class CreateDemoReportAndChart < ActiveRecord::Migration[7.0]
  # rubocop:disable Metrics/MethodLength
  def change
    within_renalware_schema(suffix: :demo) do
      create_view(:reporting_example_data, sql_definition: <<-SQL.squish)
        with dates as (
          SELECT date_trunc('day', dd)::date AS dt
              FROM generate_series
              ( '2023-01-01'::timestamp
              , '2023-12-31'::timestamp
              , '1 week'::interval) dd
        )
        select dates.dt::date as date,
        (10 + 9*random())*(row_number() over()) as series1,
        (2 + 7*random())*(row_number() over()) as series2
        from dates;
      SQL
    end
  end
  # rubocop:enable Metrics/MethodLength
end
