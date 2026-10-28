class CreateAdminDashboardDefinition < ActiveRecord::Migration[8.0]
  class Role < ActiveRecord::Base
    self.table_name = "renalware.roles"
  end

  class Widget < ActiveRecord::Base
    self.table_name = "renalware.system_dashboard_widgets"
  end

  class WidgetRole < ActiveRecord::Base
    self.table_name = "renalware.system_dashboard_widget_roles"
  end

  class Dashboard < ActiveRecord::Base
    self.table_name = "renalware.system_dashboards"
  end

  class Placement < ActiveRecord::Base
    self.table_name = "renalware.system_dashboard_placements"
  end

  ROLE_NAMES = %w(admin super_admin devops).freeze

  # wrapper_classes are Tailwind utilities. The admin dashboard grid lives in the view; these
  # classes must also be present in scanned source so Tailwind does not purge them.
  WIDGETS = [
    {
      key: "user_activity",
      name: "User activity",
      class_name: "Renalware::System::UserActivityComponent",
      position: 10
    },
    {
      key: "integration_activity",
      name: "Integration activity",
      class_name: "Renalware::Monitoring::Mirth::IntegrationActivityComponent",
      position: 20
    },
    {
      key: "users_awaiting_approval",
      name: "Users awaiting approval",
      class_name: "Renalware::System::UsersAwaitingApprovalComponent",
      position: 30
    }
  ].freeze

  WRAPPER_CLASSES = "min-w-0".freeze

  def up
    roles = Role.where(name: ROLE_NAMES).to_a
    dashboard = Dashboard.find_or_create_by!(key: "admin", user_id: nil) do |d|
      d.name = "Admin"
      d.description = "Global admin dashboard"
    end

    WIDGETS.each do |attrs|
      widget = Widget.find_or_create_by!(key: attrs[:key]) do |w|
        w.name = attrs[:name]
        w.class_name = attrs[:class_name]
      end
      roles.each { |role| WidgetRole.find_or_create_by!(widget_id: widget.id, role_id: role.id) }
      Placement.find_or_create_by!(dashboard_id: dashboard.id, widget_id: widget.id) do |p|
        p.position = attrs[:position]
        p.settings = { "wrapper_classes" => WRAPPER_CLASSES }
      end
    end
  end

  def down
    keys = WIDGETS.pluck(:key)
    widget_ids = Widget.where(key: keys).pluck(:id)
    dashboard = Dashboard.find_by(key: "admin", user_id: nil)
    Placement.where(dashboard_id: dashboard.id, widget_id: widget_ids).delete_all if dashboard
    Dashboard.where(id: dashboard.id).delete_all if dashboard && !Placement.exists?(dashboard_id: dashboard.id)
    WidgetRole.where(widget_id: widget_ids).delete_all
    Widget.where(id: widget_ids).delete_all
  end
end
