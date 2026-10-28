require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding admin dashboard" do
    admin_roles = Renalware::Role.where(name: %w(admin super_admin devops))
    dashboard = System::Dashboard.find_or_create_by!(key: "admin", user_id: nil) do |d|
      d.name = "Admin"
      d.description = "Global admin dashboard"
    end

    [
      ["user_activity", "User activity", "Renalware::System::UserActivityComponent"],
      ["integration_activity", "Integration activity",
       "Renalware::Monitoring::Mirth::IntegrationActivityComponent"],
      ["users_awaiting_approval", "Users awaiting approval",
       "Renalware::System::UsersAwaitingApprovalComponent"]
    ].each.with_index(1) do |(key, name, class_name), index|
      widget = System::DashboardWidget.find_or_create_by!(key:) do |w|
        w.name = name
        w.class_name = class_name
      end
      admin_roles.each { |role| widget.widget_roles.find_or_create_by!(role:) }
      dashboard.placements.find_or_create_by!(widget:) do |placement|
        placement.position = index * 10
        placement.settings = { "wrapper_classes" => "min-w-0" }
      end
    end
  end
end
