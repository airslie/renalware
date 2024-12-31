describe "Creating an event", :js do
  it "successfully adds a simple event" do
    user = login_as_clinical
    patient = create(:patient, by: user)

    event_type = create(:access_clinic_event_type, name: "Access--Clinic")
    visit new_patient_event_path(patient)

    slim_select "Access--Clinic", from: "Event type"
    sleep 0.1
    expect(page).to have_content("Description")

    fill_in "Description", with: "Test"
    click_on t("btn.create")

    events = Renalware::Events::Event.for_patient(patient)
    expect(events.length).to eq(1)
    event = events.first
    expect(event.event_type_id).to eq(event_type.id)
    expect(event.description).to eq("Test")
  end
end
