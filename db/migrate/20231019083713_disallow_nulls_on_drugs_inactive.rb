class DisallowNullsOnDrugsInactive < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      safety_assured do
        %i(drugs drug_dmd_virtual_medical_products drug_vmp_classifications).each do |table_name|
          execute("update #{table_name} set inactive = false where inactive is null")
          change_column_null table_name, :inactive, false
        end
      end
    end
  end
end
