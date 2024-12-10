class CreateRemoteMonitoringTables < ActiveRecord::Migration[7.2]
  def change
    within_renalware_schema do
      create_table :remote_monitoring_frequencies do |t|
        t.interval :period, null: false
        t.datetime :deleted_at, index: true
        t.integer :position, null: false, index: true, default: 1
        t.timestamps null: false
        t.index :period, where: "deleted_at IS NULL", unique: true
      end

      create_table :remote_monitoring_referral_reasons do |t|
        t.text :description, null: false
        t.datetime :deleted_at, index: true
        t.integer :position, null: false, index: true, default: 1
        t.timestamps null: false
        t.index :description, where: "deleted_at IS NULL", unique: true
      end
    end
  end
end
