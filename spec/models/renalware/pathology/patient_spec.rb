# frozen_string_literal: true

module Renalware::Pathology
  describe Patient do
    it { is_expected.to have_one(:current_observation_set) }

    describe ".fetch_current_observation_set" do
      context "when the patient doesn't have one" do
        it "builds one ready for saving" do
          patient = create(:pathology_patient)

          obs_set = patient.fetch_current_observation_set

          expect(obs_set).not_to be_nil
          expect(obs_set).not_to be_persisted
        end
      end

      context "when the patient already has one" do
        it "returns the existing one" do
          patient = create(:pathology_patient)
          obs_set = patient.build_current_observation_set

          obs_set.save!

          obs_set = patient.fetch_current_observation_set
          expect(obs_set).to be_persisted
        end
      end
    end
  end
end
