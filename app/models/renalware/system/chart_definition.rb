module Renalware
  module System
    # Backed by JSONB, stored in view_metadata.filters, a model to allow
    # us to specify chart config, and a helper method to generate the json series data for a
    # chart when given an AR relation.
    class ChartDefinition
      include StoreModel::Model
      attribute :x_axis_column, :string
      attribute :series_columns, array: true, default: []

      # TODO: remove rescue nil and find a way to warn the user of errors.
      # rubocop:disable Style/RescueModifier
      def generate_json(relation)
        series_columns.map do |series_column|
          {
            name: series_column.to_s.humanize,
            data: relation.map { |x|
              [
                x.send(x_axis_column.to_sym).to_datetime.to_i + 1000,
                (x.send(series_column.to_sym) rescue nil)
              ]
            }
          }
        end.to_json
      end
      # rubocop:enable Style/RescueModifier
    end
  end
end
