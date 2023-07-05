class AddIndexToDryWeights < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      safety_assured do
        add_index(
          :clinical_dry_weights,
          [:patient_id, :created_at],
          order: { patient_id: :asc, created_at: :desc },
          name: :index_clinical_dry_weights_on_patient_id_created_at,
          comment: "Ordered index to speed up latest dry weight queries"
        )
      end
    end
  end
end
