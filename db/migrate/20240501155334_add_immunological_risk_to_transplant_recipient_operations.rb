class AddImmunologicalRiskToTransplantRecipientOperations < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      add_column :transplant_recipient_operations, :immunological_risk, :string
    end
  end
end
