module Renalware
  module Patients
    module Ingestion
      # Responsible for mapping attributes from a message to attributes
      # to domain models.
      #
      class MessageMapper
        def initialize(message)
          @message = message
        end

        attr_reader :message

        def fetch
          raise NotImplementedError
        end
      end
    end
  end
end
