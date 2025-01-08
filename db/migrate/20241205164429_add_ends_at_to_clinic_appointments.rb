class AddEndsAtToClinicAppointments < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      add_column :clinic_appointments, :ends_at, :datetime, null: true
    end
  end
end
