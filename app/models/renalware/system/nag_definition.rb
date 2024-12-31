module Renalware
  module System
    class NagDefinition < ApplicationRecord
      validates :description, presence: true, uniqueness: true
      validates :sql_function_name, presence: true
      validates :importance, presence: true

      # Execute the SQL function specified in the nag definition, passing the patient id.
      # It returns OUT params severity (an enum, eg high) and content (eg a date as a string).
      # Parse the results into an Nag object for ease of handling.
      # Do not allow a SQL error to stop UI rendering, so in this case return a Null object.
      def execute_sql_function_for(patient)
        result = ActiveRecord::Base.connection.execute(<<-SQL.squish)
          select * from #{sql_function_name}(#{patient.id})
        SQL
        row = result.first

        Nag.new(
          definition: self,
          severity: row["out_severity"],
          date: row["out_date"],
          value: row["out_value"]
        )
      rescue StandardError => e
        # TODO: Is there a way to inform a developer that the nag function failed?
        # One way would be to return the error description in a pseudo nag object
        # and render this in a hidden div? To think about.
        Nag.new(definition: self, sql_error: e)
      end

      # alias :cache_key_with_version :cache_key
    end
  end
end
