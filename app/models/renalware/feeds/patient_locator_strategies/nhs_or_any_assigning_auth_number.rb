module Renalware
  module Feeds
    module PatientLocatorStrategies
      # As used at MSE.
      # This finds a patient by matching nhs_number or any
      # one of their hospital numbers, where each number on the PID patient_id_list has been mapped
      # to a local_patient_id* column in PatientIdentification#identifiers
      class NHSOrAnyAssigningAuthNumber
        include Callable

        pattr_initialize [:patient_identification!]
        delegate :identifiers, to: :patient_identification

        # Build an AR query to try and find the target patient
        def call
          patients = Renalware::Patient.none

          # OR together all the identifiers eg if the PID segment contained an NHS number and one
          # hospital number: WHERE ("nhs_number= '123' OR local_patient_id = '456')
          identifiers.each do |column, hosp_no|
            patients = patients.or(Renalware::Patient.where(column => hosp_no))
          end

          if patients.length > 1 # avoid a count query
            raise ArgumentError, "More than one patient matches! #{identifiers}"
            # Will go back in the queue
          else
            patients.first # may be null if no match
          end
        end
      end
    end
  end
end
