describe "Creating a swab", :js do
  it "allows creation of a new swab event" do
    user = login_as_clinical
    patient = create(:patient, by: user)
    event_type = create(:swab_event_type)

    visit new_patient_swab_path(patient)

    fill_trix_editor with: "some notes"

    find("div.radio_buttons", text: "Swab type").choose("MRSA")
    find("div.radio_buttons", text: "Swab result").choose("Positive")

    click_on t("btn.create")

    events = Renalware::Events::Event.for_patient(patient)
    expect(events.length).to eq(1)
    event = events.first
    expect(event.event_type_id).to eq(event_type.id)
    expect(event.document.type).to eq("mrsa")
    expect(event.document.result).to eq("pos")
    expect(event.notes).to match("some notes")
  end
end
