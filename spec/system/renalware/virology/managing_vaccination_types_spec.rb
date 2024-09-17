# frozen_string_literal: true

describe "Managing vaccination types" do
  it "displays a list of vaccination types" do
    create(:vaccination_type, code: "aaa", name: "Bbb")
    login_as_super_admin
    visit virology_vaccination_types_path

    expect(page).to have_http_status(:success)
    expect(page).to have_current_path(virology_vaccination_types_path)
    expect(page).to have_content("Vaccination Types")
    expect(page).to have_content("Bbb")
    expect(page).to have_content("aaa")
  end

  context "when editing" do
    it "allows valid input" do
      type = create(:vaccination_type, code: "aaa", name: "Bbb")
      login_as_super_admin
      visit edit_virology_vaccination_type_path(type)

      fill_in "Name", with: "New name"
      click_on "Save"

      expect(page).to have_current_path(virology_vaccination_types_path)
      expect(page).to have_content("New name")
    end

    it "disallows a name that has already been taken by an active type" do
      create(:vaccination_type, code: "xx", name: "Xxx", deleted_at: nil)
      type = create(:vaccination_type, code: "aaa", name: "Bbb")
      login_as_super_admin
      visit edit_virology_vaccination_type_path(type)

      fill_in "Name", with: "Xxx" # will already exist
      click_on "Save"

      expect(page).to have_no_current_path(virology_vaccination_types_path)
      expect(page).to have_content("already used")
    end

    it "disallows a name that has already been taken by a deleted type" do
      create(:vaccination_type, code: "xx", name: "Xxx", deleted_at: 1.year.ago)
      type = create(:vaccination_type, code: "aaa", name: "Bbb")
      login_as_super_admin
      visit edit_virology_vaccination_type_path(type)

      fill_in "Name", with: "Xxx" # will already exist
      click_on "Save"

      expect(page).to have_no_current_path(virology_vaccination_types_path)
      expect(page).to have_content("already used")
    end
  end

  context "when adding" do
    it "allows valid data and converts the code to lowercase underscored" do
      login_as_super_admin
      visit new_virology_vaccination_type_path

      fill_in "Name", with: "New name"
      fill_in "Code", with: "A New Code"
      click_on "Create"

      expect(page).to have_current_path(virology_vaccination_types_path)
      expect(page).to have_content("New name")
      expect(page).to have_content("a_new_code")
    end

    it "disallows a code that has already been used in a deleted type" do
      create(:vaccination_type, code: "xxx", name: "Xxx", deleted_at: 1.year.ago)
      login_as_super_admin
      visit new_virology_vaccination_type_path

      fill_in "Name", with: "Ab"
      fill_in "Code", with: "xxx"
      click_on "Create"

      expect(page).to have_content("already used")
    end
  end

  it "allows deleting a type" do
    travel_to(1.year.ago) do
      create(:vaccination_type, code: "aaa", name: "Bbb")
    end

    travel_to(1.day.ago) do
      login_as_super_admin
      visit virology_vaccination_types_path

      within("table.vaccination_types") do
        click_on "Delete"
      end

      expect(page).to have_current_path(virology_vaccination_types_path)
      # We still display the type but it will be show a deleted_at datetime
      expect(page).to have_content("Bbb")
      expect(page).to have_content(I18n.l(Time.zone.now)) # deleted_at
    end
  end
end
