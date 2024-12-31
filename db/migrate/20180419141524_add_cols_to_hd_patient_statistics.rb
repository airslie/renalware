class AddColsToHDPatientStatistics < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      add_column :hd_patient_statistics,
                 :pathology_snapshot,
                 :jsonb,
                 index: { using: :gin },
                 default: {},
                 null: false
    end
  end
end
