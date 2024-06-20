class AddWeightingToMedicationRoutes < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      safety_assured do
        add_column :medication_routes, :weighting, :integer, default: 0, null: false
        add_index :medication_routes, :weighting
      end
    end
  end
end
