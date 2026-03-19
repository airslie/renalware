# frozen_string_literal: true

describe "Viewing a patient's appointments" do
  let(:user) { @current_user }
  let(:clinic) { create(:clinic) }
  let(:patient) { create(:clinics_patient, by: user) }

  describe "GET index" do
    it "responds successfully" do
      appointment = create(:appointment, patient:, starts_at: 1.year.from_now)

      get patient_appointments_path(patient)

      expect(response).to be_successful
      expect(response.body).to include(I18n.l(appointment.starts_at))
    end
  end

  describe "appointment clinic visit links" do
    it "links to view and edit when the current user can edit the clinic visit" do
      clinic_visit = create(:clinic_visit, patient:, by: user, created_at: 1.hour.ago)
      create(:appointment, patient:, starts_at: 1.year.from_now, becomes_visit_id: clinic_visit.id)

      get patient_appointments_path(patient)

      expect(response.body).to include(%(>View</a>))
      expect(response.body).to include(patient_clinic_visit_path(patient, clinic_visit))
      expect(response.body).to include(%(>Edit</a>))
      expect(response.body).to include(edit_patient_clinic_visit_path(patient, clinic_visit))
    end

    it "links only to view when the current user cannot edit the clinic visit" do
      clinic_visit = create(:clinic_visit, patient:, by: user, created_at: 8.days.ago)
      create(:appointment, patient:, starts_at: 1.year.from_now, becomes_visit_id: clinic_visit.id)

      get patient_appointments_path(patient)

      expect(response.body).to include(%(>View</a>))
      expect(response.body).to include(patient_clinic_visit_path(patient, clinic_visit))
      expect(response.body).not_to include(%(>Edit</a>))
    end
  end
end
