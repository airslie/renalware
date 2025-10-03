# frozen_string_literal: true

module Renalware
  class Letters::LetterTimelineRow < TimelineRow
    register_output_helper :sanitize

    private

    def type
      TableCell { "Letter (#{state})" }
    end

    def description
      TableCell { @record.topic&.text || @record.description }
    end

    def detail
      TableDetailRow(COLUMNS) { sanitize @record.body }
    end

    def state
      I18n.t @record.state, scope: %i(enums letter state)
    end
  end
end
