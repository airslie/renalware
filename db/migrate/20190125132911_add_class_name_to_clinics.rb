class AddClassNameToClinics < ActiveRecord::Migration[5.2]
  def change
    add_column :clinic_clinics, :visit_class_name, :string
  end
end
