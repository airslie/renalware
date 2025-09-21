module Renalware
  module Patients::Merges
    # Used as part of the patient merge process.
    # For a schema.table, update the FK that points to renalware.patients.id so that references
    # to the minor patient point to the major patient.
    # E.g.
    #  update renalware.events set patient_id = <major_patient_id>
    #  where patient_id = <minor_patient_id>;
    # The use raw SQL because the patient merge process initially using SQL to find all
    # tables with a FK to renalware.patients.id and then iterates over them.
    # As its using raw SQL we need to be very careful to validate the arguments.
    # See MergeableTablesQuery
    #
    class UpdatePatientFkQuery
      IDENT_RE = /\A[a-zA-Z_][a-zA-Z0-9_$]*\z/

      pattr_initialize [
        :major_patient_id!,
        :minor_patient_id!,
        :schema!,
        :table!,
        :column!
      ]

      def call
        validate_arguments
        update_records
      end

      private

      # To think about:
      # - updating schema.table.updated_at?
      # - updating patients.updated_at?
      def update_records
        sql = <<-SQL.squish
          UPDATE
            #{quoted_table}
          SET
            #{quoted_column} = $1
          WHERE
            #{quoted_column} = $2 AND #{quoted_column} <> $1
        SQL

        int_type = ActiveRecord::Type::Integer.new
        binds = [
          ActiveRecord::Relation::QueryAttribute.new(nil, Integer(major_patient_id), int_type),
          ActiveRecord::Relation::QueryAttribute.new(nil, Integer(minor_patient_id), int_type)
        ]

        # This returns the number of rows updated
        connection.exec_update(sql, "UpdatePatientFkQuery#update", binds)
      end

      def quoted_table
        "#{connection.quote_table_name(schema)}.#{connection.quote_table_name(table)}"
      end

      def quoted_column = @quoted_column ||= connection.quote_column_name(column)
      def connection = ActiveRecord::Base.connection

      # Some rather over the top argument validation but this is a
      # potentially dangerous operation so better safe than sorry.
      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      def validate_arguments
        raise ArgumentError, "major_patient_id is required" if major_patient_id.blank?
        raise ArgumentError, "minor_patient_id is required" if minor_patient_id.blank?
        raise ArgumentError, "schema is required" if schema.blank?
        raise ArgumentError, "table is required" if table.blank?
        raise ArgumentError, "column is required" if column.blank?
        if minor_patient_id == major_patient_id
          raise ArgumentError, "minor_patient_id must be different from major_patient_id"
        end

        Integer(major_patient_id)
        Integer(minor_patient_id)

        [schema, table, column].each do |ident|
          raise ArgumentError, "invalid identifier: #{ident.inspect}" unless ident.match?(IDENT_RE)
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
    end
  end
end
