# frozen_string_literal: true

describe "View Admission Request" do
  it "Use the top menu to navigate to the list of admission requests" do
    login_as_clinical
    visit dashboard_path

    within "#top-menu-bar" do
      click_on "Patients"
      click_on "Admission Requests"
    end

    expect(page).to have_current_path(admissions_requests_path)
  end
end
