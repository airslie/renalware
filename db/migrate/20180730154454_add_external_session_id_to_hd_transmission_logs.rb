class AddExternalSessionIdToHDTransmissionLogs < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      add_column :hd_transmission_logs,
                 :external_session_id,
                 :string,
                 index: true
      add_reference :hd_transmission_logs, :session, index: true, null: true
    end
  end
end
