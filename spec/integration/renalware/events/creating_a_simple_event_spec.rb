require "rails_helper"
require "test_support/ajax_helpers"

RSpec.describe "Creating an event", type: :feature, js: true do
  include AjaxHelpers
  before do
    login_as_clinician
    page.driver.add_headers("Referer" => root_path)
  end

  let(:patient) { create(:patient) }

  context "adding a simple event" do
    it "works" do
      # event_type = create(:events_type, name: "Access--Clinic")
      create(:events_type, name: "Access--Clinic")
      visit new_patient_event_path(patient)

      # select "Access--Clinic", from: "Event type"
      expect(page).to have_content("Description")
      fill_in "Description", with: "Test"

      click_on "Save"

      events = Renalware::Events::Event.for_patient(patient)
      expect(events.length).to eq(1)
      event = events.first
      # expect(event.event_type_id).to eq(event_type.id)
      expect(event.description).to eq("Test")
    end
  end
end