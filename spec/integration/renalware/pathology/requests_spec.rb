# frozen_string_literal: true

require "rails_helper"

describe "Configuring Requests", type: :request do
  describe "GET index" do
    let!(:clinic_1) { create(:clinic) }
    let!(:patient_1) { create(:pathology_patient) }
    let!(:consultant_1) { create(:pathology_consultant) }
    let!(:request_1) do
      create(
        :pathology_requests_request,
        clinic: clinic_1,
        patient: patient_1,
        consultant: consultant_1
      )
    end
    let!(:clinic_2) { create(:clinic) }
    let!(:patient_2) { create(:pathology_patient) }
    let!(:consultant_2) { create(:pathology_consultant) }
    let!(:request_2) do
      create(
        :pathology_requests_request,
        clinic: clinic_2,
        patient: patient_2,
        consultant: consultant_2
      )
    end

    it "responds with a list of request forms" do
      get pathology_requests_requests_path

      expect(response).to be_successful
    end
  end

  describe "GET show" do
    let!(:request) do
      create(
        :pathology_requests_request,
        clinic: create(:clinic),
        patient: create(:pathology_patient),
        consultant: create(:pathology_consultant)
      )
    end

    it "responds with a list of request forms" do
      get pathology_requests_request_path(id: request.id, format: "pdf")

      expect(response).to be_successful
      expect(response.headers["Content-Type"]).to eq("application/pdf")
    end
  end
end
