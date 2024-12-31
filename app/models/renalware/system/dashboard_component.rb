module Renalware
  module System
    # Represents an instance of a component on a dashboard
    class DashboardComponent < ApplicationRecord
      belongs_to :component
      belongs_to :dashboard
      validates :position, presence: true
      validates :position, uniqueness: { scope: [:dashboard_id] }
      validates :dashboard, presence: true
      validates :component, presence: true
    end
  end
end
