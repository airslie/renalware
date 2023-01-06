# frozen_string_literal: true

require "rails_helper"

describe "Managing PD PET Adequacy Results", type: :request do
  let(:patient) { Renalware::PD.cast_patient(create(:patient, by: user)) }
  let(:user) { create(:user) }

  describe "GET new" do
    it "responds with a form" do
      get new_patient_pd_pet_adequacy_result_path(patient)

      expect(response).to be_successful
    end
  end

  describe "POST create" do
    it "responds with success" do
      params = { pet_adequacy: FactoryBot.attributes_for(:pet_adequacy_result) }
      post patient_pd_pet_adequacy_results_path(patient, params)

      follow_redirect!
      expect(response).to be_successful
    end
  end

  describe "GET edit" do
    it "responds with a form" do
      pet_adequacy_result = create(:pet_adequacy_result, patient: patient, by: user)
      get edit_patient_pd_pet_adequacy_result_path(patient_id: patient,
                                                   id: pet_adequacy_result)

      expect(response).to be_successful
    end
  end

  describe "PUT update" do
    it "responds with success" do
      pet_adequacy_result = create(:pet_adequacy_result, patient: patient, by: user)
      params = {
        patient_id: patient,
        id: pet_adequacy_result.id,
        pet_adequacy: { daily_urine: 0.1 }
      }
      put patient_pd_pet_adequacy_result_path(params)
      expect(response).to be_successful
    end
  end

  describe "GET show" do
    it "responds with success" do
      pet_adequacy_result = create(:pet_adequacy_result, patient: patient, by: user)
      params = {
        patient_id: patient,
        id: pet_adequacy_result.id
      }

      get patient_pd_pet_adequacy_result_path(params)

      expect(response).to be_successful
    end
  end
end
