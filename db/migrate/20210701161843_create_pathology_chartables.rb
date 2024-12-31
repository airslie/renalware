class CreatePathologyChartables < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_enum :pathology_chart_axis, %w(y1 y2)

      change_table :pathology_observation_descriptions do |t|
        t.boolean :virtual, default: false, null: false
        t.string :chart_colour
        t.boolean :chart_logarithmic, default: false, null: false
        t.string(
          :chart_sql_function_name,
          comment: "A custom json-returning SQL function returning a calculated/derived series. " \
                   "Must accept an integer (patient id) and date (start date to search from)"
        )
      end

      create_table(
        :pathology_charts,
        comment: "Pre-defined charts that can appear in various places"
      ) do |t|
        t.string(
          :title,
          null: false,
          index: { unique: true },
          comment: "Appears on the page next to the chart"
        )
        t.text :description, comment: "For admin use only"
        t.integer :display_group, null: false, default: 1, comment: "For grouping charts"
        t.integer :display_order, null: false, default: 1, comment: "Position of chart in a group"
        t.string :scope, null: false, default: "charts", comment: "E.g. page location for chart"
        t.boolean :enabled, null: false, default: true, index: true
        t.references(
          :owner,
          foreign_key: { to_table: :users },
          comment: "If set, only this user sees this chart"
        )
        t.jsonb :options, default: {}, comment: "Optional hash to override default chart settings"
        t.timestamps null: false
      end

      create_table(
        :pathology_chart_series,
        comment: "Defines the series displayed on a predefined chart"
      ) do |t|
        t.references :chart, foreign_key: { to_table: :pathology_charts }, null: false
        t.references(
          :observation_description,
          foreign_key: { to_table: :pathology_observation_descriptions },
          null: false,
          index: { name: "idx_path_cst_obx" }
        )
        t.enum :axis, enum_type: :pathology_chart_axis, null: false, default: "y1"
        t.string(
          :colour,
          comment: "Usually null, but can override the colour in the chartable row here"
        )
        t.jsonb :options, default: {}, comment: "Optional hash to override default series settings"
        t.timestamps null: false
      end
    end
  end
end
