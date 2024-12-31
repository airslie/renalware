module Renalware
  module Patients
    module Ingestion
      class Command
        include Callable

        attr_reader :message

        def self.for(message)
          CommandFactory.new.for(message)
        end

        def initialize(message)
          @message = message
        end

        def call
          raise NotImplementedError
        end

        def find_patient
          Feeds::PatientLocator.call(
            :adt,
            patient_identification: message.patient_identification
          )
        end
      end
    end
  end
end
