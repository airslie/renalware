describe "Consultant management" do
  let(:user) { create(:user) }

  it "enables me to list consultants" do
    login_as_super_admin

    consultants = [
      create(:consultant, code: "C1", name: "Consultant1", by: user),
      create(:consultant, code: "C2", name: "Consultant2", by: user)
    ]

    visit consultants_path

    expect(page).to have_content("Consultants")

    consultants.each do |consultant|
      expect(page).to have_content(consultant.code)
      expect(page).to have_content(consultant.name)
    end
  end

  it "enables me to add a consultant" do
    login_as_super_admin

    visit consultants_path

    within(".page-heading") do
      click_on "Add"
    end

    fill_in "Name", with: "Consultant1"
    fill_in "Code", with: "C1"
    fill_in "Telephone", with: "000"
    click_on "Create"

    expect(Renalware::Clinics::Consultant.count).to eq(1)
    expect(Renalware::Clinics::Consultant.first).to have_attributes(
      name: "Consultant1",
      code: "C1",
      telephone: "000"
    )
  end

  it "enables me to edit a consultant" do
    login_as_super_admin

    consultant = create(:consultant, name: "Name1", code: "Code1", telephone: "00")

    visit consultants_path

    within("#clinics_consultant_#{consultant.id}") do
      click_on "Edit"
    end

    fill_in "Name", with: "Name2"
    fill_in "Code", with: "Code2"
    fill_in "Telephone", with: "11"
    click_on "Save"

    expect(consultant.reload).to have_attributes(
      name: "Name2",
      code: "Code2",
      telephone: "11"
    )
  end

  it "enables me to soft delete a consultant" do
    login_as_super_admin

    consultant = create(:consultant, name: "Name1", code: "Code1")

    visit consultants_path

    within("#clinics_consultant_#{consultant.id}") do
      click_on "Delete"
    end

    deleted_consultant = Renalware::Clinics::Consultant.with_deleted.find(consultant.id)
    expect(deleted_consultant.deleted_at).not_to be_nil
  end
end
