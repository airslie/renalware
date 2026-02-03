class CreatePathJsonFunctions < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      reversible do |direction|
        direction.up do
          load_function "pathology_chart_series_v01.sql"
          load_function "pathology_chart_series_product_ca_phos_v01.sql"
        end
        direction.down do
          execute(<<~SQL.squish)
            DROP FUNCTION renalware.pathology_chart_series(integer, integer, date);
            DROP FUNCTION renalware.pathology_chart_series_product_ca_phos(integer, date);
          SQL
        end
      end
    end
  end
end
