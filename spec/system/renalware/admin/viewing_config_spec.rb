# frozen_string_literal: true

describe "Viewing the system config" do
  it do
    login_as_super_admin
    visit admin_dashboard_path

    within ".side-nav--admin" do
      click_on "Config Settings"
    end

    expect(page).to have_current_path(admin_config_path)
    within(".page-heading") do
      expect(page).to have_content("Config Settings")
    end
  end
end
