describe "Create remote monitoring registration event", :js do
  it "creates successfully" do
    user = login_as_clinical
    patient = create(:patient, family_name: "XXX", given_name: "Jon", by: user)

    create(:remote_monitoring_registration)
    create(:remote_monitoring_frequency, :"4M")
    create(:remote_monitoring_referral_reason, description: "ABC")

    visit renalware.new_patient_event_path(patient)

    slim_select "Remote Monitoring Registration", from: "Event type"

    # Custom inputs load via js
    sleep 0.5

    #
    # First use invalid inputs to test re-display of form and routing etc
    #
    # Leave reason and frequency unselected, and use a non-number for creatinine
    fill_in "Baseline creatinine", with: "not a number"

    expect {
      click_on "Create"
    }.not_to change(Renalware::Events::Event, :count)

    expect(page).to have_content("is not a number")
    expect(page).to have_content("can't be blank")

    #
    # Now add valid inputs
    #
    select "ABC", from: "Referral reason"
    select "4 months", from: "Monitoring frequency"
    fill_in "Baseline creatinine", with: "123.1"

    expect {
      click_on "Create"
    }.to change(Renalware::Events::Event, :count).by(1)

    expect(page).to have_current_path(renalware.patient_events_path(patient))

    registration = Renalware::Events::Event.where(patient: patient).last
    expect(registration.document).to have_attributes(
      referral_reason: "ABC",
      frequency_iso8601: "P4M", # iso8601 format
      frequency: "4 months",
      baseline_creatinine: 123.1
    )
  end
end
