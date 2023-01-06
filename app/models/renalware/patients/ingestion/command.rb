# frozen_string_literal: true

module Renalware
  module Patients
    module Ingestion
      class Command
        attr_reader :message

        def initialize(message)
          @message = message
        end

        def self.call(...)
          new(...).call
        end

        def self.for(message)
          CommandFactory.new.for(message)
        end

        def call
          raise NotImplementedError
        end

        def find_patient
          Feeds::PatientLocator.call(message.patient_identification)
        end
      end
    end
  end
end
