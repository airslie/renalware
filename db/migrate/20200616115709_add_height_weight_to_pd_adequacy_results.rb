class AddHeightWeightToPDAdequacyResults < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      add_column :pd_adequacy_results, :height, :float
      add_column :pd_adequacy_results, :weight, :float
    end
  end
end
