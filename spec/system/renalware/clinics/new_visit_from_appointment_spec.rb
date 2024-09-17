# frozen_string_literal: true

describe "New Visit from existing Appointment" do
  describe "GET index" do
    context "with no appointment id" do
      it "does not pre-populate the form" do
        user = login_as_clinical
        patient = create(:clinics_patient, by: user)

        visit new_patient_clinic_visit_path(patient)

        expect(find_field("Date").value).to eq ""
        expect(find_field("Time").value).to eq ""
        expect(find_field("Clinic").value).to eq ""
      end
    end

    context "with an appointment id passed" do
      it "pre-populates the form with the details copied from the appointment" do
        user = login_as_clinical
        clinic = create(:clinic) # consultant: user)
        patient = create(:clinics_patient, by: user)
        appointment = create(:appointment,
                             patient: patient,
                             clinic: clinic,
                             starts_at: Time.zone.now)

        visit new_patient_clinic_visit_path(patient, appointment_id: appointment.id)

        expect(find_field("Date").value).to eq(l(appointment.starts_at.to_date))
        expect(find_field("Time").value).to eq(appointment.starts_at.strftime("%H:%M"))
        expect(find_field("Clinic").value).to eq(appointment.clinic.id.to_s)

        within ".document" do
          click_on t("btn.create")
        end

        expect(patient.clinic_visits.length).to eq(1)
        expect(appointment.reload.becomes_visit_id).to eq(patient.clinic_visits.first.id)
      end
    end
  end
end
