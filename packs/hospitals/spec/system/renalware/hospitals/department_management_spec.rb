# frozen_string_literal: true

describe "Department Management" do
  it "displays a list of hospital departments" do
    login_as_clinical
    centre = create(:hospital_centre, name: "HospA", code: "ABC")
    other_centre = create(:hospital_centre, name: "HospB", code: "XYZ")
    department = create(
      :hospital_department,
      name: "DeptA",
      hospital_centre: centre,
      address: build(:address, telephone: "123", email: "depta@hospa.com")
    )
    other_department = create(
      :hospital_department,
      name: "DeptX",
      hospital_centre: other_centre,
      address: build(:address)
    )

    visit hospitals.centre_departments_path(centre, department)

    expect(page).to have_http_status(:success)
    expect(page).to have_no_content(other_department.name)
    expect(page).to have_content("DeptA")
    expect(page).to have_content("123")
    expect(page).to have_content("depta@hospa.com")
    expect(page).to have_content(department.hospital_centre.name)
  end

  it "add a department" do
    login_as_super_admin
    centre = create(:hospital_centre, name: "HospA", code: "HospA")
    uk = create(:united_kingdom)

    visit hospitals.centres_path

    expect(page).to have_content("HospA")

    within("table tr#centre_#{centre.id} .departments_count") do
      click_on "View"
    end

    expect(page).to have_current_path(hospitals.centre_departments_path(centre))

    within ".page-actions" do
      click_on t("btn.add")
    end

    fill_in "Name", with: "DeptA"
    fill_in "Telephone", with: "1234"
    fill_in "Email", with: "depta@hospa.com"
    fill_in "Street 1", with: "Street1"
    fill_in "Street 2", with: "Street2"
    fill_in "Street 3", with: "Street3"
    fill_in "Town", with: "TownA"
    fill_in "County", with: "CountyA"
    fill_in "Postcode", with: "GL1"
    select "United Kingdom", from: "Country"
    click_on t("btn.create")

    department = centre.reload.departments.first
    expect(department).to have_attributes(
      name: "DeptA",
      hospital_centre_id: centre.id
    )
    expect(department.address).to have_attributes(
      email: "depta@hospa.com",
      telephone: "1234",
      street_1: "Street1",
      street_2: "Street2",
      street_3: "Street3",
      town: "TownA",
      county: "CountyA",
      country_id: uk.id,
      postcode: "GL1"
    )
  end

  it "edit a department" do
    login_as_super_admin
    centre = create(:hospital_centre, name: "HospA", code: "HospA")
    department = create(
      :hospital_department,
      name: "DeptA",
      hospital_centre: centre
    )

    visit hospitals.centre_departments_path(centre)

    within("table tr#department_#{department.id}") do
      click_on t("btn.edit")
    end

    fill_in "Name", with: "NewName"
    fill_in "Postcode", with: "NEW_POSTCODE"
    click_on t("btn.save")

    expect(page).to have_content("Department updated")
    expect(page).to have_current_path(hospitals.centre_departments_path(centre))

    expect(page).to have_content("NewName")
    expect(page).to have_content("NEW_POSTCODE")
  end
end
