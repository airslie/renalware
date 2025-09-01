class CreateFeedMapClinics < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      create_table :clinic_mappings do |t|
        t.string :name_in_feed, null: false
        t.references :clinic, null: true, foreign_key: { to_table: :clinic_clinics }
        t.boolean :default_clinic, null: false, default: false
        t.timestamps null: false
      end
      add_index :clinic_mappings,
                "lower(name_in_feed)",
                unique: true,
                name: "index_clinic_mappings_lower_name_in_feed",
                comment: "Case insensitive index on HL7 clinic name"
      add_index :clinic_mappings,
                :default_clinic,
                unique: true,
                where: "default_clinic = true",
                name: "index_clinic_mappings_on_default_true",
                comment: "Enforces that there can only be one default clinic"
    end
  end
end
