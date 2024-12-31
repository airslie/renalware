class CreateRenalAKIAlerts < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      create_table :renal_aki_alerts do |t|
        t.references :patient, null: false, foreign_key: true, index: true
        t.references :action,
                     foreign_key: { to_table: :renal_aki_alert_actions },
                     index: true,
                     null: true
        t.references :hospital_ward,
                     foreign_key: { to_table: :hospital_wards },
                     index: true,
                     null: true
        t.boolean :hotlist, null: false, default: false, index: true
        t.string :renal_aki_alerts, :action, :string, index: true
        t.text :notes
        t.references :updated_by, foreign_key: { to_table: :users }, index: true
        t.references :created_by, foreign_key: { to_table: :users }, index: true

        t.timestamps null: false
      end
    end
  end
end
