# frozen_string_literal: true

module Renalware
  class Events::EventTimelineItem < TimelineItem
    private

    def scope
      Events::Event.eager_load(:event_type)
    end
  end
end
