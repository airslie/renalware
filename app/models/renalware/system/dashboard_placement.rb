module Renalware
  module System
    # A widget placed on a dashboard. Ordering is by position then id; positions need not be
    # unique. settings holds presentation options, e.g. "wrapper_classes" (Tailwind utilities).
    class DashboardPlacement < ApplicationRecord
      belongs_to :dashboard, inverse_of: :placements
      belongs_to :widget, class_name: "DashboardWidget", inverse_of: :placements

      validates :dashboard, presence: true
      validates :widget, presence: true
      validates :position, presence: true
      validates :widget_id, uniqueness: { scope: :dashboard_id }

      scope :ordered, -> { order(:position, :id) }

      def wrapper_classes = settings["wrapper_classes"]
    end
  end
end
