describe "Clearing the Rails cache" do
  it "A super admin clears the Solid Cache store" do
    login_as_super_admin
    visit admin_dashboard_path

    within ".side-nav--admin" do
      click_on "Cache"
    end

    expect(page).to have_current_path(admin_cache_path)

    allow(Rails.cache).to receive(:clear)

    click_on "Clear the Application Cache"

    expect(Rails.cache).to have_received(:clear)
  end
end
