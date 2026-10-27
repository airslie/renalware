module Renalware
  module System
    class DashboardWidgetRole < ApplicationRecord
      belongs_to :widget, class_name: "DashboardWidget", inverse_of: :widget_roles
      belongs_to :role, class_name: "Renalware::Role"

      validates :widget, presence: true
      validates :role, presence: true
      validates :role_id, uniqueness: { scope: :widget_id }
    end
  end
end
