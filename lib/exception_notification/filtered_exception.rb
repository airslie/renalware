require "dumb_delegator"

module ExceptionNotification
  class FilteredException < DumbDelegator
    def message
      filter_sensitive_data(__getobj__.message)
    end

    def to_s
      filter_sensitive_data(__getobj__.to_s)
    end

    private

    def filter_sensitive_data(message)
      message.gsub(/#<Renalware.*?>/, "[FILTERED]")
    end
  end
end
