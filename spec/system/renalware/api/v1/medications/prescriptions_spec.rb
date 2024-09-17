# frozen_string_literal: true

require "devise"

describe "API request for a patient's prescriptions as JSON" do
  include PatientsSpecHelper
  let(:patient) { create(:patient) }
  let(:drug) { create(:drug, name: "Drug1") }
  let(:json) { JSON.parse(page.body) }
  let(:user) { create(:user, username: "aaaaa", authentication_token: "wWsSmmHywhYMWPM6e9ib") }

  describe "rendering json" do
    context "when no authorisation credentials passed in the query string" do
      it "forbids access to the resource" do
        visit api_v1_patient_prescriptions_path(patient)
        expect(page.status_code).to eq(401)
        expect(json["error"]).to match("Please sign in or sign up before continuing.")
      end
    end

    context "when the patient has no prescriptions" do
      it "renders json array" do
        visit api_v1_patient_prescriptions_path(
          patient_id: patient.to_param,
          username: user.username,
          token: user.authentication_token
        )

        expect(page.status_code).to eq(200)

        expect(json).to eq([])
      end
    end

    context "when the patient has prescriptions" do
      it "renders json array" do
        prescription = create(
          :prescription,
          patient: patient,
          drug: drug,
          by: user,
          dose_amount: "20",
          frequency: "daily",
          medication_route: create(:medication_route, name: "Oral")
        )

        visit api_v1_patient_prescriptions_path(
          patient_id: patient.to_param,
          username: user.username,
          token: user.authentication_token
        )

        expect(page.status_code).to eq(200)

        expect(json).to eq(
          [
            {
              "id" => prescription.id,
              "prescribed_on" => prescription.prescribed_on.to_s,
              "drug_name" => drug.name,
              "dose" => "20 mg",
              "dose_unit" => "milligram",
              "dose_amount" => prescription.dose_amount,
              "frequency" => prescription.frequency,
              "route_code" => "Oral",
              "route_description" => nil,
              "administer_on_hd" => false,
              "last_delivery_date" => nil
            }
          ]
        )
      end
    end
  end
end
