# frozen_string_literal: true

describe "Appointments" do
  describe "GET index" do
    it "responds with a ist of appointments" do
      user = login_as_clinical
      consultant = create(:consultant)
      patient = create(:clinics_patient, by: user)
      create(
        :appointment,
        patient: patient,
        clinic: create(:clinic),
        consultant: consultant,
        starts_at: Time.zone.now,
        by: user
      )

      get appointments_path

      expect(response).to be_successful
      expect(response.body).to include(patient.to_s)
      expect(response.body).to include(consultant.to_s)
    end
  end
end
