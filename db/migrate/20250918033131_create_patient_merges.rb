class CreatePatientMerges < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      create_enum :patient_merge_message_types, %w(A34 A40 manual).freeze
      create_enum :patient_merge_sources,  %w(HL7 manual).freeze
      create_enum :patient_merge_statuses, %w(in_progress completed failed).freeze

      comment = <<~COMMENT.squish
        Record and status of patient merges from external systems, such as
        HL7 A34 or A40 messages. See A34 or A40 HL7 online spec for an understanding of major
        and minor patients.
        Supports one merge pair at a time (a major patient and a minor patient) as per spec.
        If the upstream EPR requires multiple minors then they will send multiple messages.
        Note that we only create a row in this table if, on receipt of an A34 or A40 message,
        we were able to find both the major and minor patients in our system.
      COMMENT

      create_table(:patient_merge_merges, comment: comment) do |t|
        t.references :major_patient,
                     null: false,
                     foreign_key: { to_table: :patients },
                     index: true,
                     comment: "The patient that the minor patient was merged into"
        t.references :minor_patient,
                     null: false,
                     foreign_key: { to_table: :patients },
                     index: true,
                     comment: "The patient that was merged into the major patient"
        t.enum :source,
               enum_type: :patient_merge_sources,
               null: false,
               comment: "The source system of the merge, e.g., 'HL7'"
        t.enum :message_type,
               enum_type: :patient_merge_message_types,
               null: false,
               comment: "The type of merge message, e.g., 'A34' or 'A40'"
        t.enum :status,
               enum_type: :patient_merge_statuses,
               null: false,
               default: "in_progress",
               comment: "The status of the merge, e.g., 'in_progress'"
        t.text :failure_message, comment: "Populated when status is 'failed'"
        t.references :feed_message,
                     null: true,
                     foreign_key: { to_table: :feed_messages },
                     index: true,
                     comment: "The feed message that triggered this merge"
        t.timestamps null: false
      end
    end
  end
end
