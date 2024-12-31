# TODO

describe "Patient Group Directions (PGD)" do
  it "listing PGDs" do
    pgd = create(:patient_group_direction, name: "PGD name1", code: "PCG code1")
    login_as_super_admin
    visit drugs_patient_group_directions_path

    within(".non-patient-page") do
      expect(body).to have_content("Patient Group Directions")
      expect(page).to have_content(pgd.name)
      expect(page).to have_content(pgd.code)
    end
  end

  it "creating a PGD" do
    login_as_super_admin
    visit renalware.new_drugs_patient_group_direction_path

    within(".non-patient-page") do
      expect(body).to have_content("New Patient Group Direction")
      fill_in "Name", with: "PGD Name1"
      fill_in "Code", with: "pgd code1"
      click_on "Create"
    end

    expect(page).to have_current_path(drugs_patient_group_directions_path)

    pgd = Renalware::Drugs::PatientGroupDirection.last
    expect(pgd).to have_attributes(
      name: "PGD Name1",
      code: "pgd code1"
    )
  end

  it "editing a PGD" do
    login_as_super_admin
    create(:patient_group_direction, name: "PGD name1", code: "PCG code1")
    visit drugs_patient_group_directions_path

    within "table.pgds tbody tr:first" do
      click_on "Edit"
    end

    within(".non-patient-page") do
      fill_in "Name", with: "PGD Name2"
      fill_in "Code", with: "pgd code2"
      click_on "Save"
    end

    expect(page).to have_current_path(drugs_patient_group_directions_path)

    pgd = Renalware::Drugs::PatientGroupDirection.last
    expect(pgd).to have_attributes(
      name: "PGD Name2",
      code: "pgd code2"
    )
  end

  it "deleting a PGD" do
    login_as_super_admin
    create(:patient_group_direction, name: "PGD name1", code: "PCG code1")
    visit drugs_patient_group_directions_path

    within "table.pgds tbody tr:first" do
      expect {
        click_on "Delete" \
      }.to change(Renalware::Drugs::PatientGroupDirection, :count).by(-1)
    end
  end
end
