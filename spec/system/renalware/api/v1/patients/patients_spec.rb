# frozen_string_literal: true

require "devise"

describe "API request for a single patient JSON document" do
  include PatientsSpecHelper

  let(:json) { JSON.parse(page.body) }
  let(:address) { build(:address, :in_uk) }
  let(:patient) { create(:patient, local_patient_id: "123", current_address: address) }
  let(:user) { create(:user, username: "aaaaa", authentication_token: "wWsSmmHywhYMWPM6e9ib") }

  describe "GET JSON #show" do
    context "when no authorisation credentials passed in the query string" do
      it "forbids access to the resource" do
        visit api_v1_patient_path(id: patient.local_patient_id)
        expect(page.status_code).to eq(401)
        expect(json["error"]).to match("Please sign in or sign up before continuing.")
      end
    end

    context "when the address is blank" do
      it "renders json successfully" do
        patient.current_address.destroy!

        visit api_v1_patient_path(
          id: patient.local_patient_id,
          username: user.username,
          token: user.authentication_token
        )

        expect(page.status_code).to eq(200)

        address = json["current_address"]
        expect(address).to be_a(Hash)
        expect(address.values.compact).to eq([])
      end
    end

    it "renders patient json" do
      patient.current_address.update(email: "email@example.com", telephone: "118118")

      visit api_v1_patient_path(
        id: patient.local_patient_id,
        username: user.username,
        token: user.authentication_token
      )

      expect(page.status_code).to eq(200)

      expect(json).to eq(
        "id" => patient.id,
        "secure_id" => patient.secure_id,
        "nhs_number" => patient.nhs_number,
        "local_patient_id" => patient.local_patient_id,
        "local_patient_id_2" => patient.local_patient_id_2,
        "local_patient_id_3" => patient.local_patient_id_3,
        "local_patient_id_4" => patient.local_patient_id_4,
        "local_patient_id_5" => patient.local_patient_id_5,
        "title" => patient.title,
        "given_name" => patient.given_name,
        "family_name" => patient.family_name,
        "born_on" => patient.born_on.to_s,
        "died_on" => patient.died_on&.to_s,
        "sex" => patient.sex&.code,
        "ethnicity" => patient.ethnicity&.code,
        "current_address" => {
          "street_1" => address.street_1,
          "street_2" => address.street_2,
          "street_3" => address.street_3,
          "town" => address.town,
          "county" => address.county,
          "region" => address.region,
          "postcode" => address.postcode,
          "country" => "United Kingdom",
          "telephone" => "118118",
          "email" => "email@example.com"
        },
        "prescriptions_url" =>
          renalware.api_v1_patient_prescriptions_path(patient_id: patient),
        "hd_profile_url" =>
          renalware.api_v1_patient_hd_current_profile_path(patient_id: patient)
      )
    end
  end

  describe "GET JSON #index" do
    context "when last_patient_id is not passed" do
      it "renders an empty list of patients because we only support requests with a " \
         "last_patient_id param" do
        visit api_v1_patients_path(
          username: user.username,
          token: user.authentication_token
        )
      end
    end
  end
end
