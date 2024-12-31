module Renalware
  module System
    # Stores the data returned from calling a NagDefinition.sql_function_name
    class Nag
      attr_reader :definition, :severity, :value, :date, :sql_error

      delegate :relative_link, to: :definition, allow_nil: true

      def initialize(opts = {})
        @definition = opts.fetch(:definition)
        @severity = opts[:severity]&.to_sym
        @date = parse_date(opts[:date])
        @value = opts[:value]
        @sql_error = opts[:sql_error]
      end

      private

      # Date from sql function may not be a date so parse it. Unlike a table or view, AR does not
      # know the column type.
      def parse_date(date)
        return if date.blank?
        return date if date.is_a?(Date)

        Date.parse(date)
      rescue Date::Error
        nil
      end
    end
  end
end
