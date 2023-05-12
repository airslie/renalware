# frozen_string_literal: true

require "rails_helper"

describe "Creating an medication review event", js: true do
  it "captures extra data" do
    user = login_as_clinical
    patient = create(:patient, by: user)

    create(:biopsy_event_type)
    event_type = create(:medication_review_event_type)

    visit new_patient_event_path(patient)

    # Do a dance to catch any errors switching event type
    slim_select "Renal biopsy", from: "Event type"
    sleep 0.1
    slim_select "Medication Review", from: "Event type"
    sleep 0.1

    within("form.new_events_event") do
      click_on "Save"
    end

    expect(page).to have_current_path patient_events_path(patient)

    events = Renalware::Events::Event.for_patient(patient)
    expect(events.length).to eq(1)
    expect(events.first.event_type_id).to eq(event_type.id)
  end
end
