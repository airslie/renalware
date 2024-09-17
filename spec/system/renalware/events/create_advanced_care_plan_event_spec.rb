# frozen_string_literal: true

describe "Creating an Advanced Care Plan event", js: true do
  context "when adding the event" do
    it "allows a user to also select the state from an event-specfic dropdown" do
      user = login_as_clinical
      patient = create(:patient, by: user)

      event_type = create(:advanced_care_plan_event_type)

      visit new_patient_event_path(patient)

      slim_select event_type.name, from: "* Event type"

      # something funky is happeining with the ajax, so wait a bit
      sleep 0.1
      select "ACP required but not started", from: "State"

      click_on t("btn.create")

      events = Renalware::Events::Event.for_patient(patient)
      expect(events.length).to eq(1)
      event = events.first
      expect(event.event_type_id).to eq(event_type.id)
      expect(event.document.state).to eq("required_but_not_started")
    end
  end
end
