# rubocop:disable-next Metrics/BlockNesting
FactoryBot.define do
  factory :dashboard_widget, class: "Renalware::System::DashboardWidget" do
    sequence(:key) { |n| "widget_#{n}" }
    sequence(:name) { |n| "Widget #{n}" }
    class_name { "Renalware::System::UsersAwaitingApprovalComponent" }

    transient do
      role_names { [] }
    end

    trait :user_activity do
      class_name { "Renalware::System::UserActivityComponent" }
    end

    trait :integration_activity do
      class_name { "Renalware::Monitoring::Mirth::IntegrationActivityComponent" }
    end

    trait :users_awaiting_approval do
      class_name { "Renalware::System::UsersAwaitingApprovalComponent" }
    end

    after(:build) do |widget, evaluator|
      evaluator.role_names.each do |role_name|
        role = Renalware::Role.find_or_create_by!(name: role_name)
        widget.widget_roles.build(role:)
      end
    end
  end

  factory :dashboard, class: "Renalware::System::Dashboard" do
    sequence(:key) { |n| "dashboard_#{n}" }
    sequence(:name) { |n| "Dashboard #{n}" }
  end

  factory :dashboard_placement, class: "Renalware::System::DashboardPlacement" do
    dashboard
    widget factory: %i(dashboard_widget)
    sequence(:position) { |n| n * 10 }
    settings { {} }
  end
end
