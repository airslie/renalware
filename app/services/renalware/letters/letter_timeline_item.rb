# frozen_string_literal: true

module Renalware
  class Letters::LetterTimelineItem < TimelineItem
    private

    def scope
      Letters::Letter.eager_load(:topic, :author)
    end
  end
end
