module Renalware
  module System
    # Executes the given SQL function and logs the returned OUT params to an APILog event.
    # The SQL function might not be volatile and return null or 0 in those fields,
    # but if it creates or updates rows it should.
    # The definition of the SQL fn should look like this:
    #
    #   CREATE FUNCTION renalware.test_fn(out records_added integer, out records_updated integer)
    #     LANGUAGE plpgsql AS $$
    #   BEGIN
    #     select into records_added, records_updated 123, 456;
    #   END $$;
    #
    class SqlFunctionJob < ApplicationJob
      class InvalidSqlFunctionDefinitionError < StandardError; end
      class InvalidSqlFunctionRowCountError < StandardError; end

      def perform(sql_fn_name_and_args)
        APILog.with_log(sql_fn_name_and_args) do |log|
          # We start a new transaction here so that if there is an error inside the SQL fn,
          # the error we capture in APILog.error is the actual error and not a
          # PG::InFailedSqlTransaction error
          ActiveRecord::Base.transaction do
            result = execute_function(sql_fn_name_and_args)
            validate_result(result)
            # Save the returned OUT params to the log object. We rely on the out param names
            # matching the API Log column names e.g.
            # results.to_a.first => {"records_added"=>123, "records_updated"=>456}
            log.assign_attributes(**result.to_a.first)
            true
          end
        end
      end

      def execute_function(sql_fn_name_and_args)
        ActiveRecord::Base.connection.execute(<<-SQL.squish)
          select * from #{sql_fn_name_and_args};
        SQL
      end

      # Validate the SQL fn has the correct OUT arguments names
      def validate_result(result)
        if result.fields.sort != %w(records_added records_updated)
          raise(
            InvalidSqlFunctionDefinitionError,
            "SQL function should have integer OUT parameters 'rows_added' and 'rows_updated'"
          )
        end
      end
    end
  end
end
