describe "Changing a patient's modality", :js do
  it "hides notes and warns when death is selected" do
    warning = "Please note that after saving the Death modality, " \
              "all current prescriptions will be terminated!"
    login_as_clinical
    patient = create(:patient)
    create(:modality_description, :death)
    create(:modality_description, :hd)
    create(:modality_change_type, :other, default: true)

    visit new_patient_modality_path(patient)

    expect(page).to have_field("Notes")

    accept_alert(warning) do
      select "Death", from: "Description"
    end

    expect(page).to have_no_field("Notes")

    select "HD", from: "Description"

    expect(page).to have_field("Notes")
  end

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
