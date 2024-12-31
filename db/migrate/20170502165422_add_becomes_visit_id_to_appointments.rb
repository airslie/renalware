class AddBecomesVisitIdToAppointments < ActiveRecord::Migration[5.0]
  def up
    add_column :clinic_appointments, :becomes_visit_id, :integer
    add_foreign_key :clinic_appointments, :clinic_visits, column: :becomes_visit_id
  end

  def down
    remove_column :clinic_appointments, :becomes_visit_id
  end
end
