class AddCodeToReligions < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      safety_assured do
        add_column :patient_religions, :code, :string, comment: "eg 'E' for 'Jain'"
        add_index :patient_religions, :code
      end
    end
  end
end
