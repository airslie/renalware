module Renalware
  module Feeds
    module Files
      class ImportJobFactory
        # Returns the active job class required to process files of type file_type
        def self.job_class_for(file_type)
          "Renalware::Feeds::Files::#{file_type.name.camelize}::ImportJob".constantize
        end
      end
    end
  end
end
