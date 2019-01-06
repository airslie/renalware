# frozen_string_literal: true

require "rails_helper"

describe "Viewing historical HD Profiles", type: :request do
  describe "GET index" do
    it "renders successfully" do
      patient = create(:hd_patient)
      get patient_hd_historical_profiles_path(patient)

      expect(response).to be_successful
    end
  end

  describe "GET show" do
    context "with a (soft) deleted profile" do
      it "renders successfully" do
        patient = create(:hd_patient)
        profile = create(:hd_profile, patient: patient)
        profile.delete # soft delete ie updates deleted_at

        get patient_hd_historical_profile_path(patient, profile)

        expect(response).to be_successful
      end
    end

    context "with a current deleted profile" do
      it "raises an exception as the profile is not historical (deleted)" do
        patient = create(:hd_patient)
        profile = create(:hd_profile, patient: patient)

        expect {
          get patient_hd_historical_profile_path(profile.patient, profile)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
