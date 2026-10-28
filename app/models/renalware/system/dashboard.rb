module Renalware
  module System
    # The description in data of a dashboard displayed in the UI, for example the global
    # 'admin' dashboard (key "admin"), or in future a user's customised copy of a dashboard.
    # A dashboard comprises widgets placed on it (see DashboardWidget and DashboardPlacement).
    class Dashboard < ApplicationRecord
      belongs_to :user
      has_many :placements, class_name: "DashboardPlacement", inverse_of: :dashboard,
                            dependent: :destroy
      has_many :widgets, through: :placements

      validates :key, presence: true, uniqueness: { conditions: -> { where(user_id: nil) } }
      validates :name, presence: true

      def self.global(key) = find_by(key:, user_id: nil)

      def visible_placements_for(user)
        placements
          .where(widget_id: DashboardWidget.visible_to(user).select(:id))
          .includes(:widget)
          .ordered
      end
    end
  end
end
