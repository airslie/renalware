module Renalware
  module System
    module Dashboards
      # Allowlist of view components that may be rendered from a dashboard widget row.
      # Never constantize a class name read from the database without going through here.
      module ComponentRegistry
        CLASS_NAMES = %w(
          Renalware::System::UserActivityComponent
          Renalware::Monitoring::Mirth::IntegrationActivityComponent
          Renalware::System::UsersAwaitingApprovalComponent
        ).freeze

        def self.class_names = CLASS_NAMES

        def self.fetch(class_name)
          return unless CLASS_NAMES.include?(class_name)

          class_name.safe_constantize
        end
      end
    end
  end
end
