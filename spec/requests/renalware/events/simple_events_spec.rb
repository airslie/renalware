describe "Simple events" do
  describe "PATCH update" do
    let(:event_type) { create(:event_type, name: "Simple") }
    let(:patient) { create(:patient) }

    context "with valid attributes" do
      it "updates and redirects to the patient's events list" do
        event = create(:simple_event, event_type: event_type, patient: patient)

        params = {
          events_event: {
            description: "123",
            date_time: "12-Nov-2018",
            event_type_id: event_type.id
          }
        }

        patch patient_event_path(patient, event), params: params

        expect(response).to have_http_status(:redirect)
        expect(Renalware::Events::Event).to exist(params[:events_event])

        follow_redirect!

        expect(response).to be_successful
      end
    end

    context "with invalid attributes" do
      it "responds with a form" do
        event = create(:simple_event, event_type: event_type, patient: patient)

        params = {
          events_event: {
            description: "123",
            date_time: "",
            event_type_id: event_type.id
          }
        }
        patch patient_event_path(patient, event), params: params

        expect(response).to be_successful
      end
    end
  end
end
