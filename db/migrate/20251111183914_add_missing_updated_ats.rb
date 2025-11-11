class AddMissingUpdatedAts < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      unless column_exists?(:clinical_allergies, :updated_at)
        add_column(:clinical_allergies, :updated_at, :datetime)
      end
      add_timestamps(:pathology_requests_patient_rules, default: -> { "CURRENT_TIMESTAMP" })
    end
  end
end
