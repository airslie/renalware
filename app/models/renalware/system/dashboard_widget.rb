module Renalware
  module System
    # A dashboard widget registers a Ruby view component (see Dashboards::ComponentRegistry)
    # for use on dashboards, along with the roles whose users may see it. A widget with no
    # roles is visible to no one. See also Dashboard and DashboardPlacement.
    class DashboardWidget < ApplicationRecord
      has_many :widget_roles, class_name: "DashboardWidgetRole", foreign_key: :widget_id,
                              inverse_of: :widget, dependent: :destroy
      has_many :roles, through: :widget_roles
      has_many :placements, class_name: "DashboardPlacement", foreign_key: :widget_id,
                            inverse_of: :widget, dependent: :restrict_with_exception

      validates :key, presence: true, uniqueness: true
      validates :name, presence: true, uniqueness: true
      validates :class_name, presence: true, uniqueness: true
      validate :class_name_is_registered

      scope :visible_to, lambda { |user|
        where(id: DashboardWidgetRole.where(role_id: user.roles.select(:id)).select(:widget_id))
      }

      def component_class = Dashboards::ComponentRegistry.fetch(class_name)

      private

      def class_name_is_registered
        return if class_name.blank? || component_class

        errors.add(:class_name, "is not a registered dashboard component")
      end
    end
  end
end
