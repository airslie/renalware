# frozen_string_literal: true

require "rails_helper"

describe "Viewing clinical profile" do
  let(:patient) { Renalware::Clinical.cast_patient(create(:patient, by: user)) }
  let(:user) { @current_user }

  describe "GET show" do
    it "responds successfully" do
      get patient_clinical_profile_path(patient_id: patient.to_param)
      expect(response).to be_successful
    end
  end

  describe "GET edit" do
    it "responds successfully" do
      get edit_patient_clinical_profile_path(patient_id: patient.to_param)
      expect(response).to be_successful
    end
  end

  describe "PUT update" do
    it "responds successfully" do
      hospital_centre = create(:hospital_centre)
      url = patient_clinical_profile_path(patient_id: patient.to_param)
      params = {
        clinical_profile: {
          hospital_centre_id: hospital_centre.id,
          document: {
            history: { smoking: "ex", alcohol: "rarely" },
            diabetes: { diagnosis: "true", diagnosed_on: "12-12-2017" }
          }
        }
      }

      put(url, params: params)

      expect(response).to have_http_status(:redirect)
      follow_redirect!
      expect(response).to be_successful

      history = patient.reload.document.history
      expect(history.alcohol).to eq("rarely")
      expect(history.smoking).to eq("ex")

      expect(patient.document.diabetes.diagnosis).to be(true)
      expect(patient.hospital_centre).to eq(hospital_centre)
      expect(patient.document.diabetes.diagnosed_on).to eq(Date.parse("12-12-2017"))
    end
  end
end
