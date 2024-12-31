class AddEventsIndexOnPatientIdAndDeletedAt < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    within_renalware_schema do
      add_index(
        :events,
        [:patient_id, :deleted_at],
        where: "deleted_at is null",
        name: :index_events_on_patient_id_not_deleted,
        comment: "conditional index to speed up count()ing a patient's undeleted events",
        algorithm: :concurrently
      )
    end
  end
end
