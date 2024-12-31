module Renalware
  module Feeds
    # A superadmin dashboard component displaying the status of outgoing documents in the last
    # 30 days, with some logic to colour-code values of note, eg if the number of documents waiting
    # in the queue is >= 50
    class OutgoingDocumentsStatusComponent < ApplicationComponent
      DEFAULT_TEXT_CSS_CLASS = "text-indigo-600".freeze
      WARNING_TEXT_CSS_CLASS = "text-red-600".freeze

      attr_reader :current_user, :period_in_days, :include_chrome

      def initialize(current_user:, period_in_days: 30, include_chrome: true)
        @current_user = current_user
        @period_in_days = period_in_days.to_i
        @include_chrome = include_chrome
        super
      end

      # eg { queued: 3, sent: 300 }
      def stats
        arr = Renalware::Feeds::OutgoingDocument
          .where(created_at: period_in_days.days.ago..)
          .group(:state)
          .pluck(Arel.sql("state, count(*), max(updated_at)"))
        arr.map do |state, count, latest|
          [
            state,
            count,
            latest&.strftime("%d-%b %H:%M"),
            text_css_class_for(state.to_sym, count.to_i)
          ]
        end
      end

      def text_css_class_for(state, count)
        case state
        when :queued
          count >= 50 ? WARNING_TEXT_CSS_CLASS : DEFAULT_TEXT_CSS_CLASS
        when :errored
          count >= 5 ? WARNING_TEXT_CSS_CLASS : DEFAULT_TEXT_CSS_CLASS
        else DEFAULT_TEXT_CSS_CLASS
        end
      end
    end
  end
end
