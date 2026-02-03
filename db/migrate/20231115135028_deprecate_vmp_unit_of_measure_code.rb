class DeprecateVMPUnitOfMeasureCode < ActiveRecord::Migration[7.0]
  def up
    safety_assured do
      # The unit_of_measure_code column is now replaced by
      # active_ingredient_strength_numerator_uom_code.
      # Copy any values across to the new column (where empty) and then rename the column.
      execute(<<~SQL.squish)
        update renalware.drug_dmd_virtual_medical_products
        set active_ingredient_strength_numerator_uom_code = unit_of_measure_code
        where
          coalesce(unit_of_measure_code, '') != ''
          and coalesce(active_ingredient_strength_numerator_uom_code, '') = ''
      SQL

      rename_column(
        :drug_dmd_virtual_medical_products,
        :unit_of_measure_code,
        :unit_of_measure_code_deprecated
      )
    end
  end

  def down
    safety_assured do
      rename_column(
        :drug_dmd_virtual_medical_products,
        :unit_of_measure_code_deprecated,
        :unit_of_measure_code
      )
    end
  end
end
