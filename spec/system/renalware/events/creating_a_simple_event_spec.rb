# frozen_string_literal: true

require "rails_helper"

describe "Creating an event", js: true do
  context "when adding a simple event" do
    it "works" do
      user = login_as_clinical
      patient = create(:patient, by: user)

      event_type = create(:access_clinic_event_type, name: "Access--Clinic")
      visit new_patient_event_path(patient)

      slim_select "Access--Clinic", from: "Event type"

      expect(page).to have_content("Description")

      fill_in "Description", with: "Test"
      click_on t("btn.save")

      events = Renalware::Events::Event.for_patient(patient)
      expect(events.length).to eq(1)
      event = events.first
      expect(event.event_type_id).to eq(event_type.id)
      expect(event.description).to eq("Test")
    end
  end
end
