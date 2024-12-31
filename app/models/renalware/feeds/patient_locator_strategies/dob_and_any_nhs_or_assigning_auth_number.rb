module Renalware
  module Feeds
    module PatientLocatorStrategies
      # As used at MSE.
      # This finds a patient by matching their DOB (if present) plus an nhs_number or any
      # one of their hospital numbers, where each number on the PID patient_id_list has been mapped
      # to a local_patient_id* column in PatientIdentification#identifiers
      class DobAndAnyNHSOrAssigningAuthNumber
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

          # Store the query so far, ie without the DOB 'where' clause below
          query_by_number_only = patients

          # Add an AND where condition so we might end up with
          #   WHERE ("nhs_number= '123' OR local_patient_id = '456') AND born_on = '2000-01-01'
          patients = patients.where(born_on: born_on) if born_on.present?

          # avoid a count query by using #length
          if patients.length == 1
            patients.first
          elsif patients.length > 1
            raise ArgumentError, "More than one patient matches! #{identifiers}"
          elsif query_by_number_only.exists? # patients.length == 0 so be sure to return nil
            # No number+dob match, but there is a partial match by number only - if could be the
            # patient's DOB is incorrect in RW and we are for example receiving an ADT^A31 to
            # correct it. Make sure we return nil.
            Feeds::Log.create!(
              log_type: :close_match,
              log_reason: :number_hit_dob_miss,
              patient: query_by_number_only.first,
              message: nil, # TODO: inject feed_message_id somehow
              note: born_on
            )
            nil
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
