class AddIndexToHDSessionsStationId < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    within_renalware_schema do
      add_index :hd_sessions, :hd_station_id, algorithm: :concurrently
    end
  end
end
