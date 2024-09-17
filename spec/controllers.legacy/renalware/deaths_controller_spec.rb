# frozen_string_literal: true

require "rails-controller-testing"

module Renalware
  describe Patients::DeathsController, type: :controller do
    routes { Engine.routes }
    let(:user) { @current_user }
    let(:patient) do
      create(:patient, by: user).tap do |pat|
        create(
          :modality,
          patient_id: pat.id,
          description: create(:death_modality_description),
          by: user
        )
      end
    end

    describe "index" do
      it "responds with success" do
        get :index

        expect(response).to be_successful
      end
    end

    describe "GET edit" do
      it "responds with success" do
        get :edit, params: { patient_id: patient.to_param }

        expect(response).to be_successful
      end
    end

    describe "PUT update" do
      context "with valid attributes" do
        it "updates death details" do
          cause = create(:cause_of_death)
          time = Date.parse(Time.zone.now.to_s)
          location_of_death = create(:death_location, :hospital)

          put(
            :update,
            params: {
              patient_id: patient.to_param,
              patient: {
                died_on: time,
                actual_death_location_id: location_of_death.id,
                first_cause_id: cause.id,
                death_notes: "abc"
              }
            }
          )

          expect(response).to redirect_to(patient_clinical_profile_path(patient))

          expect(patient.reload).to have_attributes(
            died_on: time,
            actual_death_location: location_of_death,
            death_notes: "abc",
            first_cause_id: cause.id
          )
        end
      end

      context "with invalid attributes" do
        it "fails to update death details" do
          put :update, params: { patient_id: patient.to_param, patient: { died_on: nil } }

          expect(response).to render_template(:edit)
        end
      end
    end
  end
end
