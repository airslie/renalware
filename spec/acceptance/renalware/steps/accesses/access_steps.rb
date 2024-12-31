module Renalware
  module Accesses
    module AccessSteps
      extend ActiveSupport::Concern

      def accesses_patient
        @accesses_patient ||= Renalware::Accesses.cast_patient(patient)
      end
    end
  end
end
