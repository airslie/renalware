describe "Updating a Event triggers an event_updated broadcast" do
  context "when updating a simple event" do
    class TestEventListener
      def event_updated(event); end
    end

    let!(:original_map) {
      Renalware.config.broadcast_subscription_map["Renalware::Events::UpdateEvent"].dup
    }

    before do
      Renalware.config.broadcast_subscription_map["Renalware::Events::UpdateEvent"] <<
        "TestEventListener"
    end

    after do
      Renalware.config.broadcast_subscription_map["Renalware::Events::UpdateEvent"] =
        original_map
    end

    it "broadcasts a Wisper 'event_updated' message" do
      skip "This is waiting for feature/heroic to be merged which supports event editing"

      patient = create(:patient)
      event_type = create(:event_type, name: "Simple")
      event = create(:simple_event, event_type: event_type, patient: patient)
      listener = TestEventListener.new
      allow(TestEventListener).to receive(:new).and_return(listener)
      allow(listener).to receive(:event_updated)

      params = {
        events_event: {
          description: "123",
          date_time: "12-Nov-2018",
          event_type_id: event_type.id
        }
      }
      post patient_event_path(patient, event, params: params)

      expect(response).to be_redirect # ie success
      expect(listener).to have_received(:event_updated)
    end
  end
end
