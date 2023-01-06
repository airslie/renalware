# frozen_string_literal: true

module Renalware
  module Feeds
    module PatientLocatorStrategies
      # As used at MSE.
      # This finds a patient by matching their DOB (if present) plus an nhs_number or any
      # one of their hospital numbers, where each number on the PID patient_id_list has been mapped
      # to a local_patient_id* column in PatientIdentification#identifiers
      class DobAndAnyNHSOrAssigningAuthNumber
        pattr_initialize [:patient_identification!]
        delegate :identifiers, to: :patient_identification

        def self.call(**kwargs)
          new(**kwargs).call
        end

        # Build an AR query to try and find the target patient
        def call
          patients = Renalware::Patient.none

          # OR together all the identifers eg if the PID segment contained an NHS number and one
          # hospital number: WHERE ("nhs_number= '123' OR local_patient_id = '456')
          identifiers.each do |column, hosp_no|
            patients = patients.or(Renalware::Patient.where(column => hosp_no))
          end

          # Add an AND where condition so we might end up with
          #   WHERE ("nhs_number= '123' OR local_patient_id = '456') AND born_on = '2000-01-01'
          patients = patients.where(born_on: born_on) if born_on.present?

          if patients.length > 1 # avoid a count query
            raise ArgumentError, "More than one patient matches! #{identifiers}"
            # Will go back in the queue
          else
            patients.first # may be null if no match
          end
        end

        private

        def born_on
          return if patient_identification.born_on.blank?

          Date.parse(patient_identification.born_on)
        end
      end
    end
  end
end
