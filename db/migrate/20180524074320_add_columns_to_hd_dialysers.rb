class AddColumnsToHDDialysers < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      add_column :hd_dialysers,
                 :membrane_surface_area,
                 :decimal, precision: 10, scale: 2
      add_column :hd_dialysers,
                 :membrane_surface_area_coefficient_k0a,
                 :decimal, precision: 10, scale: 2
    end
  end
end
