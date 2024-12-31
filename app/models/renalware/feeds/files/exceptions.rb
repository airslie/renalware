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
