describe "Remove Admission Request", :js do
  include AjaxHelpers

  it "Clicking remove soft delete the request and removes it from the list" do
    user = login_as_clinical
    request = create(:admissions_request, by: user)

    visit admissions_requests_path

    # Prevent alert from popping up i.e. auto accept it.
    page.execute_script("window.confirm = function(){ return true; }")
    within "#admissions_request_#{request.id}" do
      find(:css, ".remove").click
    end

    expect(page).to have_css("table.admissions_requests tbody tr", count: 0)
  end
end
