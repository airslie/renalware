class AddColsToClinicAppointments < ActiveRecord::Migration[8.0]
  def change
    within_renalware_schema do
      safety_assured do
        change_table :clinic_appointments do |t|
          t.text :source_clinic_name, comment: "The name of the clinic in the source system"
        end
      end
    end
  end
end
