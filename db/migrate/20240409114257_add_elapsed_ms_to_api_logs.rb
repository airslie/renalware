class AddElapsedMSToAPILogs < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      safety_assured do
        add_column :system_api_logs, :elapsed_ms, :decimal, comment: "Used for benchmarking"
      end
    end
  end
end
