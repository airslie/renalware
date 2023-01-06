# frozen_string_literal: true

module Renalware
  module System
    class APILog < ApplicationRecord
      validates :identifier, presence: true
      validates :status, presence: true
      STATUS_WORKING = "working"
      STATUS_DONE = "done"
      STATUS_ERROR = "error"

      def self.with_log(identifier, **args)
        log = create!(identifier: identifier, status: STATUS_WORKING, **args)
        yield(log) if block_given?
        log.update!(status: STATUS_DONE)
        log
      rescue StandardError => e
        log.update(
          status: STATUS_ERROR,
          error: "#{$ERROR_INFO}\nBacktrace:\n\t#{e.backtrace.join("\n\t")}"
        )
        raise e
      end
    end
  end
end
