module Renalware
  module System
    # The description in data of a dashboard displayed in the UI, for example
    # the 'default' dashboard a user see when they log in, a dashboard for
    # an HD nurse, or a user's customised dashboard (if we get to build that!),
    # A dashboard comprises components (see Component and DashboardComponent).
    class Dashboard < ApplicationRecord
      belongs_to :user
      has_many :dashboard_components, dependent: :restrict_with_exception
      has_many :components, through: :dashboard_components
      validates :name, uniqueness: true
      validates :name, presence: { if: -> { user_id.nil? } }
      validates :user, presence: { if: -> { name.nil? } }
    end
  end
end
