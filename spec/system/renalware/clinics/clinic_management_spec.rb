describe "Clinic management" do
  it "enables me to list clinics" do
    login_as_super_admin

    clinics = [
      create(:clinic, name: "Clinic A"),
      create(:clinic, name: "Clinic B")
    ]

    visit clinics_path

    expect(page).to have_content("Clinics")
    clinics.each do |clinic|
      expect(page).to have_content(clinic.code)
      expect(page).to have_content(clinic.name)
    end
  end

  it "enables me to add a clinic" do
    login_as_super_admin
    md = create(:modality_description, :nephrology)

    visit clinics_path

    within(".page-heading") do
      click_on "Add"
    end

    fill_in "Name", with: "My Clinic"
    fill_in "Code", with: "C1"
    select md.name, from: "Default modality for new patients assigned to this clinic"
    click_on "Create"

    expect(Renalware::Clinics::Clinic.count).to eq(1)
    expect(Renalware::Clinics::Clinic.first).to have_attributes(
      name: "My Clinic",
      code: "C1",
      default_modality_description_id: md.id
    )
  end

  it "enables me to edit a clinic" do
    login_as_super_admin

    clinic = create(:clinic, name: "Name1", code: "Code1")

    visit clinics_path

    within("#clinics_clinic_#{clinic.id}") do
      click_on "Edit"
    end

    fill_in "Name", with: "Name2"
    fill_in "Code", with: "Code2"
    click_on "Save"

    expect(clinic.reload).to have_attributes(
      name: "Name2",
      code: "Code2"
    )
  end

  it "enables me to soft delete a clinic" do
    login_as_super_admin

    clinic = create(:clinic, name: "Name1", code: "Code1")

    visit clinics_path

    within("#clinics_clinic_#{clinic.id}") do
      click_on "Delete"
    end

    deleted_clinic = Renalware::Clinics::Clinic.with_deleted.find(clinic.id)
    expect(deleted_clinic.deleted_at).not_to be_nil
  end
end
