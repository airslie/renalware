# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Patient HD MDM", type: :request do
  let(:patient) { create(:hd_patient, family_name: "Rabbit", local_patient_id: "KCH12345") }

  describe "GET show" do
    it "responds successfully" do
      create(:pathology_observation_description, code: "HGB")
      get patient_hd_mdm_path(patient)

      expect(response).to be_successful
    end
  end
end
