module Renalware
  log "Adding Appointments" do

    file_path = File.join(File.dirname(__FILE__), "appointments.csv")

    count = 0
    CSV.foreach(file_path, headers: true) do |row|
      count += 1
      days_ahead = count.even? ? 30 : 40
      starts_at = Time.now + days_ahead.days
      starts_at_array = row["starts_at"].split(":")

      Clinics::Appointment.find_or_create_by!(
        starts_at: starts_at.change({ hour: starts_at_array[0], min: starts_at_array[1] }),
        patient: Clinics::Patient.find_by(local_patient_id: row["local_patient_id"]),
        user: User.find_by(username: row["username"]),
        clinic: Clinics::Clinic.find_by(name: row["clinic_name"])
      )
    end
  end
end
