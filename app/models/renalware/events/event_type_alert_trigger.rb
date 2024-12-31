module Renalware
  module Events
    # Used to defines conditions where, for a particular event type, if the there is e.g. a case-
    # insensitive text match against the contents of the event document (eg 'COVID')
    # then an alert will be displayed in the UI (for the most recent match is there are > 1).
    class EventTypeAlertTrigger < ApplicationRecord
      belongs_to :event_type, class_name: "Events::Type"
      validates :event_type, presence: true
    end
  end
end
