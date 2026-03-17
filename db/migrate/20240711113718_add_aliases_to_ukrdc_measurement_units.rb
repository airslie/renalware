class AddAliasesToUKRDCMeasurementUnits < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      add_column :ukrdc_measurement_units, :alias, :string, array: true, default: []
    end
  end
end
