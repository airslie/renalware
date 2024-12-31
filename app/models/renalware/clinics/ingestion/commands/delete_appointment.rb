module Renalware
  module Clinics
    module Ingestion
      module Commands
        class DeleteAppointment
          include Callable

          pattr_initialize :message
          delegate :patient_identification, :pv1, :sch, to: :message
          delegate :clinic, to: :pv1

          def call
            return unless patient && appointment

            appointment.destroy
          end

          private

          def patient
            @patient ||= Feeds::PatientLocator.call(
              :adt,
              patient_identification: patient_identification
            )
          end

          def appointment
            @appointment ||= Appointment.find_by(patient: patient, visit_number: visit_number)
          end

          def visit_number
            message.siu? ? sch.visit_number : pv1.visit_number
          end
        end
      end
    end
  end
end
