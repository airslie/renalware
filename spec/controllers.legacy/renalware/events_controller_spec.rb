require "rails_helper"

module Renalware::Events
  RSpec.describe EventsController, type: :controller do

    before do
      @patient = create(:patient)
      @event_type = create(:events_type)
    end

    describe "GET new" do
      it "renders the new template" do
        get :new, params: { patient_id: @patient.id }
        expect(response).to render_template(:new)
      end
    end

    describe "POST create" do
      context "with valid attributes" do
        it "creates a new event" do
          expect do
            post :create,
                 params: {
                   patient_id: @patient,
                   events_event: {
                     events_type_id: @event_type,
                     date_time: Time.now,
                     description: "Needs blood test",
                     notes: "Arrange appointment in a weeks time."
                   }
                 }
          end.to change(Event, :count).by(1)
          expect(response).to redirect_to(patient_events_path(@patient))
        end
      end

      context "with invalid attributes" do
        it "creates a new event" do
          expect do
            post :create,
                 params: {
                   patient_id: @patient.id,
                   events_event: {
                     patient: @patient,
                     event_type: nil
                   }
                 }
          end.to change(Event, :count).by(0)
          expect(response).to render_template(:new)
        end
      end
    end

    describe "GET index" do
      it "responds with success" do
        get :index, params: { patient_id: @patient }
        expect(response).to have_http_status(:success)
      end
    end
  end
end
