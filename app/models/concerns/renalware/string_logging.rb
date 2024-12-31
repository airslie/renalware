module Renalware
  module StringLogging
    extend ActiveSupport::Concern

    def logging_to_stringio(string_io)
      logger = ActiveSupport::Logger.new(string_io)
      logger.formatter = Rails.configuration.log_formatter
      Rails.logger = ActiveSupport::TaggedLogging.new(logger)
    end
  end
end
