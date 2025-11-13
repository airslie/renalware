# frozen_string_literal: true

module Renalware
  module Patients
    module Ingestion
      module Commands
        class MergePatient
          include Callable

          pattr_initialize :message

          def call
            merge = Patients::Merges::Merge.new(
              major_patient: major_patient,
              minor_patient: minor_patient,
              message_type: message.event_type,
              source: "HL7",
              feed_message: message.record
            )
            Patients::Merges::MergePatients.call(merge: merge)
          end

          private

          def major_patient
            @major_patient ||= Feeds::PatientLocator.call(
              :adt,
              patient_identification: message.patient_identification
            )
          end

          def minor_patient
            patients = Renalware::Patient.none

            # OR together all the identifiers eg if the PID segment contained an NHS number and one
            # hospital number: WHERE ("nhs_number= '123' OR local_patient_id = '456')
            mrg.prior_hospital_identifiers.each do |column, hosp_no|
              patients = patients.or(Renalware::Patient.where(column => hosp_no))
            end

            if patients.length > 1 # avoid a count query
              raise ArgumentError, "More than one patient matches! #{identifiers}"
              # Will go back in the queue
            else
              patients.first # may be null if no match
            end
          end

          def mrg = message.mrg.first
          def identifiers = mrg.prior_hospital_identifiers
        end
      end
    end
  end
end
