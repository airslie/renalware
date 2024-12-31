describe "Creating an medication review event", :js do
  it "captures extra data" do
    user = login_as_clinical
    patient = create(:patient, by: user)

    create(:biopsy_event_type)
    event_type = create(:transplant_review_event_type)

    visit new_patient_event_path(patient)

    # Do a dance to catch any errors switching event type
    slim_select "Renal biopsy", from: "Event type"
    sleep 0.1
    slim_select "Transplant Review", from: "Event type"
    sleep 0.1

    click_on t("btn.create")

    events = Renalware::Events::Event.for_patient(patient)
    expect(events.length).to eq(1)
    expect(events.first.event_type_id).to eq(event_type.id)
  end
end
