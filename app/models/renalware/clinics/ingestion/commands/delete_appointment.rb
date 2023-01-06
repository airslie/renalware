# frozen_string_literal: true

module Renalware
  module Clinics
    module Ingestion
      module Commands
        class DeleteAppointment
          pattr_initialize :message
          delegate :patient_identification, :pv1, to: :message
          delegate :clinic, :visit_number, to: :pv1

          def self.call(message)
            new(message).call
          end

          def call
            return unless patient && appointment

            appointment.destroy
          end

          def patient
            @patient ||= Feeds::PatientLocator.call(patient_identification)
          end

          def appointment
            @appointment ||= Appointment.find_by(patient: patient, visit_number: visit_number)
          end
        end
      end
    end
  end
end
