# frozen_string_literal: true

describe "Creating a Event triggers an event_created broadcast" do
  context "when creating a simple event" do
    it "broadcasts a Wisper 'event_created' message" do
      Object.send(:remove_const, "MyEventListener") if Object.constants.include?("MyEventListener")
      Object.const_set(:MyEventListener, Class.new { def event_created(event) end })

      map = Renalware.config.broadcast_subscription_map
      map["Renalware::Events::CreateEvent"] << "MyEventListener"

      patient = create(:patient)
      event_type = create(:event_type, name: "Simple")
      listener = MyEventListener.new
      allow(MyEventListener).to receive(:new).and_return(listener)
      allow(listener).to receive(:event_created)

      params = {
        events_event: {
          description: "123",
          date_time: "12-Nov-2018",
          event_type_id: event_type.id
        }
      }
      post patient_events_path(patient, params: params)

      expect(response).to be_redirect # ie success
      expect(listener).to have_received(:event_created)
    end
  end
end
