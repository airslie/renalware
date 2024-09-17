# frozen_string_literal: true

describe "Update Admission Request", js: true do
  include AjaxHelpers

  it "Edit the request in a modal and updated it" do
    user = login_as_clinical
    request = create(:admissions_request, by: user)

    visit admissions_requests_path

    within "#admissions_request_#{request.id}" do
      click_on t("btn.edit")
    end

    wait_for_ajax

    fill_in "Notes", with: "more notes"
    click_on t("btn.save")

    wait_for_ajax

    within "#admissions_request_#{request.id}" do
      expect(page).to have_content("more notes")
    end
  end
end
