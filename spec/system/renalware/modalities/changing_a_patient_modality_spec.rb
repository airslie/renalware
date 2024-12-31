describe "Changing a patient's modality", :js do
  it "allows specifying a source hospital if the change type requires it" do
    user = login_as_clinical
    patient = create(:patient, by: user)
    create(:hospital_centre, name: "HospA", code: "HospA")
    create(:modality_description, :hd)
    create(
      :modality_change_type,
      code: "A",
      name: "MyChangeType",
      require_source_hospital_centre: true
    )

    visit patient_modalities_path(patient)
    within(".page-heading") do
      click_on "Add"
    end

    select "HD", from: "Description"

    select "MyChangeType", from: "Type of Change"
    find(class: "modality_source_hospital_centre_id")
    slim_select "HospA", from: "Source hospital centre"
    fill_in "Started on", with: I18n.l(Time.zone.today)
    fill_in "Notes", with: "Some notes"
    click_on "Create"

    expect(page).to have_current_path(patient_modalities_path(patient))

    within("#patient-modalities table tbody") do
      expect(page).to have_content("HD")
      expect(page).to have_content("MyChangeType from HospA")
    end
  end

  it "allows specifying a destination hospital if the change type requires it" do
    user = login_as_clinical
    patient = create(:patient, by: user)
    create(:hospital_centre, name: "HospA", code: "HospA")
    create(:modality_description, :hd)
    create(
      :modality_change_type,
      code: "A",
      name: "MyChangeType",
      require_destination_hospital_centre: true
    )

    visit patient_modalities_path(patient)
    within(".page-heading") do
      click_on "Add"
    end

    select "HD", from: "Description"

    select "MyChangeType", from: "Type of Change"
    find(class: "modality_destination_hospital_centre_id")
    slim_select "HospA", from: "Destination hospital centre"
    fill_in "Started on", with: I18n.l(Time.zone.today)
    fill_in "Notes", with: "Some notes"
    click_on "Create"

    expect(page).to have_current_path(patient_modalities_path(patient))

    within("#patient-modalities table tbody") do
      expect(page).to have_content("HD")
      expect(page).to have_content("MyChangeType to HospA")
    end
  end
end
