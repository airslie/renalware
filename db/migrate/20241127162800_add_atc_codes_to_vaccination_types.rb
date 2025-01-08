class AddAtcCodesToVaccinationTypes < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      add_column :virology_vaccination_types,
                 :atc_codes,
                 :string,
                 array: true,
                 default: [],
                 null: false
    end
  end
end
