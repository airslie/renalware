# frozen_string_literal: true

describe "Viewing a patient's appointments" do
  let(:user) { @current_user }
  let(:clinic) { create(:clinic) }
  let(:patient) { create(:clinics_patient, by: user) }

  describe "GET index" do
    it "responds successfully" do
      appointment = create(:appointment, patient: patient, starts_at: 1.year.from_now)

      get patient_appointments_path(patient)

      expect(response).to be_successful
      expect(response.body).to include(I18n.l(appointment.starts_at))
    end
  end
end
