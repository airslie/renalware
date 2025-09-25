module Renalware
  module Patients::Merges
    # Given a Merge object that has two patients (a major and a minor), merge the minor into
    # the major. This involves updating all tables with a patient_id foreign key to point to
    # the major patient instead of the minor patient, and then flagging the minor as
    # merged.
    # We consult Feeds::MergeRule records to determine how each table is handled.
    class MergePatients
      include Callable
      include Broadcasting

      pattr_initialize [:merge!]
      delegate :major_patient,
               :major_patient_id,
               :minor_patient,
               :minor_patient_id,
               to: :merge

      def call
        begin
          validate_arguments
          validate_rules_exist_for_all_tables
          ActiveRecord::Base.transaction do
            merge_minor_patient_into_major_patient_in_tables_with_a_patients_fk
            mark_minor_patient_as_merged
            merge.completed!
          end
        rescue StandardError => e
          # At this point the above transaction will have been rolled back
          merge.failed!(e) rescue nil # rubocop:disable Style/RescueModifier
          raise e
        end
      end

      private

      def validate_arguments
        raise ArgumentError, "merge event must be saved first" unless merge.persisted?

        # This is paranoia as the Merge should have been validated before being created
        # But worth being careful as consequences of a duff merge are serious.
        if major_patient.nil? || minor_patient.nil?
          raise ArgumentError, "merge event must have both major and minor patients"
        end

        if major_patient == minor_patient
          raise ArgumentError, "major and minor patients must be different"
        end
      end

      # Check that we have at least a fallback rule for the renalware schema. This ensures that
      # all tables without a specific rule get handled in some way.
      # For example, we might have several rules to skip certain tables (merge = false) or to
      # merge but create a warning - but we need a rule that will catch all other tables in the
      # renalware schema. There might be other schema.* rules for custom hospital schemas, but we do
      # not enforce their presence because we do not know what the tables in those schemas relate
      # to, even if they have a patient_id column.
      def validate_rules_exist_for_all_tables
        unless rules.key?("renalware.*")
          raise "Missing a renalware.* fallback rule. Please create one first."
        end
      end

      def merge_minor_patient_into_major_patient_in_tables_with_a_patients_fk
        MergeableTablesQuery.new.call do |column_reference|
          rule = rule_for(column_reference:)
          allow_pubsub_listeners_to_veto_merge_or_update_warning(rule)
          merge.operations.create!(
            column_reference: column_reference,
            merged: rule.merge?,
            updated_count: rule.merge? && merge_records(column_reference:),
            warning: rule.warning_message
          )
        end
      end

      def mark_minor_patient_as_merged
        minor_patient.update_column(:merged_into_patient_id, major_patient.id)
      end

      # PubSub listeners may veto the merge in this table by setting rule.merge = false
      # They may also append a warning message to the rule.warning attribute.
      # They could do this because they might determine that for this patient, the merge
      # might require some manual intervention for example.
      def allow_pubsub_listeners_to_veto_merge_or_update_warning(rule)
        broadcast(:before_table_merge, rule)
      end

      # Find the merge rule for schema+table or schema.*
      def rule_for(column_reference:)
        rules["#{column_reference.schema}.#{column_reference.table}"] ||
          rules["#{column_reference.schema}.*"]
      end

      # Memoize a hash of rules keyed by schema.table
      def rules
        @rules ||= Rule.all.index_by { "#{it.schema_name}.#{it.table_name}" }
      end

      # Update all records that reference the minor patient to point to the major patient,
      # and return the number of updated rows
      def merge_records(column_reference:)
        UpdatePatientFkQuery.new(
          column_reference:,
          major_patient_id:,
          minor_patient_id:
        ).call
      end

      def connection = ActiveRecord::Base.connection
    end
  end
end
