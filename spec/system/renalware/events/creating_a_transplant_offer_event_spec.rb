describe "Creating a transplant offer event", :js do
  it "captures and stores the donor id" do
    user = login_as_clinical
    patient = create(:patient, by: user)
    event_type = create(:transplant_offer_event_type)

    visit new_patient_event_path(patient)

    slim_select "Transplant Offer", from: "Event type"
    fill_in "Donor Id", with: "NHSBT-12345"
    fill_in "Description", with: "Patient would like time to consider the offer."
    fill_trix_editor with: "Spoke with transplant coordinator."

    click_on t("btn.create")

    expect(page).to have_current_path(patient_events_path(patient))
    events = Renalware::Events::Event.for_patient(patient)
    expect(events.length).to eq(1)

    event = events.first
    expect(event.event_type_id).to eq(event_type.id)
    expect(event.document.donor_id).to eq("NHSBT-12345")
    expect(event.description).to eq("Patient would like time to consider the offer.")
    expect(event.notes).to match("Spoke with transplant coordinator.")
  end
end
