require "rails_helper"

module Renalware::Pathology
  RSpec.describe CreateObservations do
    describe "#call" do
      it "takes no action if the patient is not found", :aggregate_failures do
        request_description = create(:pathology_request_description)
        observation_description = create(:pathology_observation_description)
        nonexistent_patient_id = 919191919
        params = build_params(nonexistent_patient_id, request_description, observation_description)

        expect{ subject.call(params) }.not_to change{ Observation.count }
      end

      it "creates the request and related observations", :aggregate_failures do
        patient = pathology_patient(create(:patient))
        request_description = create(:pathology_request_description)
        observation_description = create(:pathology_observation_description)
        params = build_params(patient.id, request_description, observation_description)

        expect{ subject.call(params) }.to change{ patient.reload.updated_at }

        expect(patient.observation_requests.count).to eq(1)
        expect(patient.observations.count).to eq(1)
      end

      def build_params(patient_id, request_description, observation_description)
        request_attrs = attributes_for(:pathology_observation_request)
          .merge(description_id: request_description.id)
        observation_attrs = attributes_for(:pathology_observation)
          .merge(description_id: observation_description.id)

        params = {}
        params[:patient_id] = patient_id
        params[:observation_request] = request_attrs
        params[:observation_request][:observations_attributes] = [observation_attrs]
        params
      end

      def pathology_patient(patient)
        Renalware::Pathology.cast_patient(patient)
      end
    end
  end
end
