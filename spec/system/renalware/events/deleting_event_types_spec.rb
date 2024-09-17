# frozen_string_literal: true

describe "Deleting event types" do
  it "a deleted type is visible wherever it has been used but is not available prospectively" do
    create(:event_category, name: "MyCategory")
    user = login_as_super_admin
    visit events_types_path

    # 1. Create the event type
    within(".page-actions") do
      click_on "Add"
    end

    fill_in "Event Type", with: "TestType"
    select "MyCategory", from: "Category"
    click_on "Create"
    type = Renalware::Events::Type.last

    # 2. Add an event for a patient, using this event event type
    patient = create(:patient, by: user)
    event = create(:simple_event, by: user, patient: patient, event_type: type)

    # 3. Check the event is displayed in the patient's event list with its type
    visit patient_events_path(patient)

    within("tbody#event_#{event.id}") do
      expect(page).to have_content("TestType")
    end

    # 4. Now delete the event type
    visit events_types_path

    within("##{dom_id(type)}") do
      click_on "Delete"
    end
    expect(type.reload.deleted?).to be(true)

    # 5. Go back to the events list and even though the event's type was deleted, the type name is
    #    still there.
    visit patient_events_path(patient)

    within("tbody#event_#{event.id}") do
      expect(page).to have_content("TestType")
    end

    # 6. make sure we can still edit and update the event.
    visit patient_events_path(patient)
    within("tbody#event_#{event.id}") do
      click_on "Edit"
    end
    fill_in "Description", with: "ABC"
    click_on "Save"

    # 7. Our edits are replicated in the events table.
    within("tbody#event_#{event.id}") do
      expect(page).to have_content("TestType") # unchanged
      expect(page).to have_content("ABC") # new
    end
  end
end
