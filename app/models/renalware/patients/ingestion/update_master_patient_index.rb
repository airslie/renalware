module Renalware
  module Patients
    module Ingestion
      class UpdateMasterPatientIndex
        include Callable

        pattr_initialize :hl7_message
        attr_reader :rw_patient

        delegate :patient_identification, to: :hl7_message

        def call
          return unless hl7_message.adt?

          @rw_patient = find_patient_in_renalware
          update_or_create_abridged_patient
        end

        private

        # TODO: use locator strategy
        def find_patient_in_renalware
          ::Renalware::Patient.find_by(
            local_patient_id: patient_identification.internal_id
          ) || NullObject.instance
        end

        # TODO: do we need to store all the hosp numbers?
        def update_or_create_abridged_patient
          find_or_initialize_abridged_patient.update!(
            nhs_number: patient_identification.nhs_number,
            given_name: patient_identification.given_name,
            family_name: patient_identification.family_name,
            sex: patient_identification.sex,
            title: patient_identification.title,
            suffix: patient_identification.suffix,
            born_on: patient_identification.born_on,
            died_at: patient_identification.died_at,
            patient_id: rw_patient.id,
            practice_code: hl7_message.practice_code,
            gp_code: hl7_message.gp_code
          )
        end

        def find_or_initialize_abridged_patient
          Patients::Abridgement.find_or_initialize_by(
            hospital_number: patient_identification.internal_id
          )
        end
      end
    end
  end
end
