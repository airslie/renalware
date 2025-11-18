module Renalware
  module Patients::Merges
    # Find all tables in the primary database that have a foreign key pointing to
    # renalware.patients.id - usually these will be in the renalware schema but not always, and
    # usually called patient_id ..but not always.
    # Note the query pay return the same table more than once if it has multiple FKs to patients.id
    # (transplant_donations).
    class MergeableTablesQuery
      include Callable

      # NEVER include these tables in a merge!
      ALWAYS_EXCLUDE_TABLES = %w(
        patient_merge_merges
        patients
        patient_master_index
        feed_replay_requests
        feed_logs
      ).freeze

      SQL_TABLES_WITH_PATIENT_FK = <<-SQL.squish.freeze
        SELECT
          tc.table_schema,
          tc.table_name,
          kcu.column_name
        FROM information_schema.table_constraints AS tc
        JOIN information_schema.key_column_usage AS kcu
          ON tc.constraint_name = kcu.constraint_name
        AND tc.table_schema    = kcu.table_schema
        JOIN information_schema.constraint_column_usage AS ccu
          ON ccu.constraint_name = tc.constraint_name
        AND ccu.table_schema    = tc.table_schema
        WHERE tc.constraint_type = 'FOREIGN KEY'
          AND ccu.table_schema = 'renalware'
          AND ccu.table_name = 'patients'
          AND ccu.column_name = 'id'
          and tc.table_name NOT IN (#{ALWAYS_EXCLUDE_TABLES.map { "'#{it}'" }.join(', ')})
        ORDER BY tc.table_schema, tc.table_name, kcu.column_name;
      SQL

      def self.call
        ActiveRecord::Base.connection.execute(SQL_TABLES_WITH_PATIENT_FK).map do |row|
          ColumnReference.new(
            row["table_schema"],
            row["table_name"],
            row["column_name"]
          )
        end
      end
    end
  end
end
