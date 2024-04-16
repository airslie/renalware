class AddAnonymiseColumnsToPatients < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      safety_assured do
        add_column :patients, :ukrdc_anonymise, :boolean, default: false, null: false
        add_column :patients, :ukrdc_anonymise_decision_on, :date
        add_column :patients, :ukrdc_anonymise_recorded_by, :string
        add_index :patients, :ukrdc_anonymise
      end
    end
  end
end
