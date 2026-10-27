describe "Viewing the admin dashboard" do
  let(:dashboard) { create(:dashboard, key: "admin", name: "Admin") }
  let(:grid_selector) { ".grid.grid-cols-1.items-start.gap-6[class~='lg:grid-cols-2']" }

  def add_widget(component, roles:, position:)
    class_name = "Renalware::#{component}"
    widget = create(:dashboard_widget, class_name:, role_names: roles)
    create(
      :dashboard_placement,
      dashboard:,
      widget:,
      position:,
      settings: { "wrapper_classes" => "min-w-0" }
    )
  end

  before do
    allow(Renalware.config).to receive(:monitoring_mirth_enabled).and_return(true)
  end

  it "lays its components out in a responsive two-column grid" do
    add_widget("System::UserActivityComponent", roles: %i(super_admin), position: 10)
    add_widget(
      "Monitoring::Mirth::IntegrationActivityComponent",
      roles: %i(super_admin),
      position: 20
    )
    add_widget(
      "System::UsersAwaitingApprovalComponent",
      roles: %i(super_admin),
      position: 30
    )
    login_as_super_admin

    visit admin_dashboard_path

    expect(page).to have_css("#{grid_selector} > .min-w-0", count: 3)
  end

  it "renders widgets in position order" do
    add_widget("System::UsersAwaitingApprovalComponent", roles: %i(admin), position: 20)
    add_widget("System::UserActivityComponent", roles: %i(admin), position: 10)
    login_as_admin

    visit admin_dashboard_path

    expect(page.text.index("User activity today")).to be < page.text.index("User Admin")
  end

  it "does not render widgets the user's roles do not permit" do
    add_widget("System::UserActivityComponent", roles: %i(super_admin), position: 10)
    add_widget("System::UsersAwaitingApprovalComponent", roles: %i(admin), position: 20)
    login_as_admin

    visit admin_dashboard_path

    expect(page).to have_css("#{grid_selector} > .min-w-0", count: 1)
    expect(page).to have_no_text("User activity today")
  end

  it "does not execute the query of a widget the user cannot see" do
    add_widget("System::UserActivityComponent", roles: %i(super_admin), position: 10)
    allow(Renalware::System::UserActivityQuery).to receive(:new).and_call_original
    login_as_admin

    visit admin_dashboard_path

    expect(Renalware::System::UserActivityQuery).not_to have_received(:new)
  end

  it "renders an empty dashboard when the admin dashboard has not been defined" do
    login_as_admin

    visit admin_dashboard_path

    expect(page).to have_text("Admin Dashboard")
  end

  it "skips a widget whose component is no longer registered" do
    add_widget("System::UsersAwaitingApprovalComponent", roles: %i(admin), position: 10)
    add_widget("System::UserActivityComponent", roles: %i(admin), position: 20)
    Renalware::System::DashboardWidget
      .find_by!(class_name: "Renalware::System::UserActivityComponent")
      .update_column(:class_name, "Renalware::Gone::Component")
    login_as_admin

    visit admin_dashboard_path

    expect(page).to have_text("Admin Dashboard")
    expect(page).to have_text("User Admin")
    expect(page).to have_css("#{grid_selector} > .min-w-0", count: 1)
  end
end
