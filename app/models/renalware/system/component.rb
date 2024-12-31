module Renalware
  module System
    # A component is the description in data of an ActionView::Component
    # in the app/components folder inside this engine.
    # Components encapsulate reusable elements of the UI.
    # Dashboard-compatible components must have a current_user arg in their
    # ctor.
    # A component can be included for example on a dashboard (see Dashboard
    # and DashboardComponent) provided component.dashboard == true.
    # A component has these properties
    #  - class_name eg "Renalware::Letters::LettersInProgress"
    #  - name eg "Letters In Progress"
    #  - dashboard - if true then this component can be added to a dashboard
    #  - roles - the roles required for a user to be able to add this component
    #            to their dashboard
    class Component < ApplicationRecord
      validates :class_name, presence: true
      validates :name, presence: true, uniqueness: true
    end
  end
end
