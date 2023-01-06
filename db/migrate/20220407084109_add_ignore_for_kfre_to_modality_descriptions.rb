class AddIgnoreForKFREToModalityDescriptions < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    within_renalware_schema do
      add_column(
        :modality_descriptions,
        :ignore_for_kfre,
        :boolean,
        null: false,
        default: false,
        comment: "If true, we will attempt to generate a KFRE on receipt of ACR/PCR result " \
                 "when the patient has this current modality"
      )
      add_index(:modality_descriptions, :ignore_for_kfre, algorithm: :concurrently)
    end
  end
end
