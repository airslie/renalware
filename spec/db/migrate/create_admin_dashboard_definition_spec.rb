require Rails.root.join("db/migrate/20261027120100_create_admin_dashboard_definition")

describe CreateAdminDashboardDefinition do
  subject(:migration) { described_class.new }

  let(:dashboard) { Renalware::System::Dashboard.find_by!(key: "admin", user_id: nil) }

  before do
    %i(admin super_admin devops).each { |name| create(:role, name) }
    migration.suppress_messages { migration.up }
  end

  it "creates the global admin dashboard with its three widgets in order" do
    expect(dashboard.placements.ordered.map { |p| p.widget.key }).to eq(
      %w(user_activity integration_activity users_awaiting_approval)
    )
  end

  it "makes every widget visible to admin, super_admin and devops" do
    expect(Renalware::System::DashboardWidget.all.map { |w| w.roles.pluck(:name).sort }).to all(
      eq(%w(admin devops super_admin))
    )
  end

  it "uses only components in the registry" do
    expect(dashboard.widgets.map(&:component_class)).to all(be_present)
  end

  it "is idempotent" do
    counts = -> { Renalware::System::DashboardPlacement.count + Renalware::System::DashboardWidgetRole.count }
    before_count = counts.call

    migration.suppress_messages { migration.up }

    expect(counts.call).to eq(before_count)
  end
end
