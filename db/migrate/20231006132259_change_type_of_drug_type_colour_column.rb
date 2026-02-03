class ChangeTypeOfDrugTypeColourColumn < ActiveRecord::Migration[7.0]
  def up
    within_renalware_schema do
      safety_assured do
        execute("update renalware.drug_types set colour = null")
        change_column :drug_types, :colour, "enum_colour_name USING colour::enum_colour_name"
        execute(<<~SQL.squish)
          update renalware.drug_types set colour = 'blue' where code = 'immunosuppressant';
          update renalware.drug_types set colour = 'yellow' where code = 'esa';
        SQL
      end
    end
  end

  def down
    within_renalware_schema do
      safety_assured do
        change_column :drug_types, :colour, :string
        execute(<<~SQL.squish)
          update renalware.drug_types set colour = '#ccfeff' where code = 'immunosuppressant';
          update renalware.drug_types set colour = '#ff9' where code = 'esa';
        SQL
      end
    end
  end
end
