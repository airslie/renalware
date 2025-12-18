module Renalware
  module Clinics
    module Ingestion
      module Commands
        class CreateOrUpdateAppointment
          include Callable

          pattr_initialize :message
          delegate :patient_identification, :pv1, :pv2, :sch, to: :message
          delegate :clinic, :consulting_doctor, :attending_doctor, to: :pv1

          # If we match incoming clinic code then we create an appointment. This might mean
          # creating the patient and consultant JIT if they do not yet exist in Renalware.
          def call
            return if rwclinic.blank?

            patient = find_or_create_patient
            existing_appointment = patient.appointments.where(visit_number: visit_number).first

            if existing_appointment.present?
              update_existing_appointment(existing_appointment)
            else
              create_new_appointment(patient)
            end
          end

          private

          def update_existing_appointment(existing_appointment)
            existing_appointment.update!(
              starts_at: appointment_starts_at,
              ends_at: appointment_ends_at,
              consultant: rwconsultant,
              clinic: rwclinic,
              source_clinic_name: pv1.clinic&.name
            )
          end

          def create_new_appointment(patient)
            Appointment.create!(
              patient: patient,
              starts_at: appointment_starts_at,
              ends_at: appointment_ends_at,
              clinic: rwclinic,
              consultant: rwconsultant,
              visit_number: visit_number,
              source_clinic_name: pv1.clinic&.name
            )
          end

          def appointment_starts_at = message.siu? ? sch.starts_at : pv2.expected_admit_date
          def appointment_ends_at   = message.siu? ? sch.ends_at : nil
          def visit_number          = message.siu? ? sch.visit_number : pv1.visit_number

          def find_or_create_patient
            # This is the standard A28/31 add/update command which will find or add the patient
            # using the contents of the PID segment
            reason = "Clinic appt"
            pat = Patients::Ingestion::Commands::AddPatient.call(message, reason).tap do |patient|
              assign_the_clinic_default_modality_to_new_patients(patient)
              update_patient_demographics(patient)
            end
            Clinics.cast_patient(pat)
          end

          def update_patient_demographics(patient)
            patient = Patients::Ingestion::MessageMappers::Patient.new(message, patient).fetch
            patient.by = SystemUser.find
            patient.save!
          end

          # If the clinic has a default modality description against it, assign that to the patient
          # if they have no modality yet.
          def assign_the_clinic_default_modality_to_new_patients(patient)
            return if patient.current_modality.present? ||
                      rwclinic.default_modality_description.blank?

            result = Modalities::ChangePatientModality.new(
              patient: patient,
              user: Renalware::SystemUser.find
            ).call(
              description_id: rwclinic.default_modality_description.id,
              started_on: Time.zone.now
            )
            raise(ActiveModel::ValidationError, result.object) if result.failure?
          end

          # A host application can choose the strategy for finding/creating (JIT) the clinic
          # referenced in an HL7 appointment message. At some sites the HL7 feed might contain
          # clinic codes that match Renalware clinic codes. At other sites the HL7 feed might
          # contain clinic names that need to be mapped to Renalware clinics using the
          # Renalware::Clinics::Mapping model.
          def rwclinic
            @rwclinic ||= ResolveClinic.call(
              name_in_feed: pv1.clinic&.name,
              code_in_feed: pv1.clinic&.code
            )
          end

          # Consultant.find_or_create_by!(code: consultant.code) do |cons|
          def rwconsultant
            @rwconsultant ||= begin
              Consultant.find_or_create_by_code!(code: consultant.code, name: consultant.name)
            end
          end

          # MSE use PV1.9 consulting_doctor
          # BLT use PV1.7 attending_doctor and consulting_doctor is blank
          def consultant
            consulting_doctor.code.present? ? consulting_doctor : attending_doctor
          end
        end
      end
    end
  end
end
