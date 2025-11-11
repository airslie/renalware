module Renalware
  module Patients::Merges
    # Used as part of the patient merge process.
    # For a schema.table, update the FK that points to renalware.patients.id so that references
    # to the minor patient point to the major patient.
    # E.g.
    #  update renalware.events set patient_id = <major_patient_id>, updated_at = now()
    #  where patient_id = <minor_patient_id>;
    # Use raw SQL because the patient merge process initially using SQL to find all
    # tables with a FK to renalware.patients.id and then iterates over them.
    # As its using raw SQL we need to be very careful to validate the arguments.
    # See MergeableTablesQuery
    #
    class UpdatePatientFkQuery
      IDENT_RE = /\A[a-zA-Z_][a-zA-Z0-9_$]*\z/

      pattr_initialize [:operation!]

      delegate :column_reference, :merge, to: :operation
      delegate :major_patient_id, :minor_patient_id, to: :merge
      delegate :schema, :table, :column, :quoted_column, :quoted_table, to: :column_reference

      def call
        validate_arguments
        update_records
      end

      private

      def update_records # rubocop:disable Metrics/MethodLength
        col = quoted_column
        sql = <<-SQL.squish
        WITH updated AS (
          UPDATE  #{quoted_table}
          SET     #{col} = $1, updated_at = #{quoted_time}
          WHERE   #{col} = $2 AND #{col} <> $1
          RETURNING id
        )
        INSERT INTO renalware.patient_merge_logs
          (operation_id, id_of_updated_record)
          SELECT #{operation.id}, updated.id
          FROM updated
        SQL

        int_type = ActiveRecord::Type::Integer.new
        binds = [
          ActiveRecord::Relation::QueryAttribute.new(nil, Integer(major_patient_id), int_type),
          ActiveRecord::Relation::QueryAttribute.new(nil, Integer(minor_patient_id), int_type)
        ]

        # This returns the number of rows updated
        ActiveRecord::Base.connection.exec_update(sql, "UpdatePatientFkQuery#update", binds)
      end

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

      # We use Rails current time rather than CURRENT_TIMESTAMP to make testing easier
      # eg using freeze_time (which CURRENT_TIMESTAMP does not respect)
      def quoted_time = ActiveRecord::Base.connection.quote(Time.current)
    end
  end
end
