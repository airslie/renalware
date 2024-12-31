describe "Manage pathology labs" do
  it "enables listing labs for a superadmin" do
    login_as_super_admin
    create(:pathology_lab, name: "Lab123")

    visit pathology_labs_path

    expect(page).to have_content("Pathology Labs")

    expect(page).to have_content("Lab123")
  end

  it "enables editing a lab" do
    login_as_super_admin
    lab = create(:pathology_lab, name: "Lab123")

    visit pathology_labs_path

    within("#pathology_lab_#{lab.id}") do
      click_on "Edit"
    end

    fill_in "Name", with: "NewLabName"
    click_on "Save"

    expect(lab.reload.name).to eq("NewLabName")
  end

  it "enables me to add a lab" do
    login_as_super_admin

    visit pathology_labs_path

    within(".page-heading") do
      click_on "Add"
    end

    fill_in "Name", with: "My Lab"
    click_on "Create"

    expect(Renalware::Pathology::Lab.count).to eq(1)
    expect(Renalware::Pathology::Lab.last).to have_attributes(
      name: "My Lab"
    )
  end
end
