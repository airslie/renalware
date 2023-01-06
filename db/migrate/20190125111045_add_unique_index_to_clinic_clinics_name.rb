class AddUniqueIndexToClinicClinicsName < ActiveRecord::Migration[5.2]
  def change
    add_index :clinic_clinics, :name, unique: true
  end
end
