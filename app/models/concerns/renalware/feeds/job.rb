module Renalware
  module Feeds
    module Job
      extend ActiveSupport::Concern

      def formatted_exception(error)
        [
          "#{error.backtrace.first}: #{error.message} (#{error.class})",
          error.backtrace.drop(1).map { |s| "\t#{s}" }
        ].join("\n")
      end

      def log(msg)
        Rails.logger.info(msg)
      end

      def find_file_in(files, pattern)
        file = files.detect { |f| f.basename.to_s.match(pattern) }
        if file.nil?
          msg = "Zip file does not contain a file with name matching #{pattern}!"
          log(msg)
          fail(msg)
        end
        file
      end
    end
  end
end
