# frozen_string_literal: true

require_dependency "renalware/feeds"

module Renalware
  module Feeds
    module Files
      class Exceptions
        class FileNotFoundError < StandardError; end

        class UnexpectedCSVFormatError < StandardError; end
      end
    end
  end
end
