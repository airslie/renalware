class CreateDieteticsMDMList < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      create_view :dietetic_mdm_patients
    end
  end
end
