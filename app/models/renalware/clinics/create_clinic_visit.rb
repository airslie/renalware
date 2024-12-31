require "success"
require "failure"

module Renalware
  module Clinics
    class CreateClinicVisit
      def self.call(patient, params)
        new(patient, params).call
      end

      def initialize(patient, params)
        @patient = patient
        @params = params
        @built_from_appointment_id = params.delete(:built_from_appointment_id)
      end

      def call
        objects = nil
        result = ClinicVisit.transaction do
          visit = build_clinic_visit
          objects = OpenStruct.new(clinic_visit: visit, appointment: appointment)
          visit.save && update_appointment_with(visit.id)
        end
        result ? ::Success.new(objects) : ::Failure.new(objects)
      end

      private

      # If the visit is being built from an appointment, e.g. a user opted to create the
      # visit from the Appointments list, we will have :built_from_appointment_id
      # in the params (its in the #new form) so we can fetch the appointment and update it to
      # indicate the visit that the appointment has transitioned to. This is currently only
      # used to provide a link to it from the Appointments list.
      def update_appointment_with(visit_id)
        return true if appointment.blank?

        appointment.becomes_visit_id = visit_id
        appointment.save
      end

      def appointment
        @appointment ||= begin
          if built_from_appointment_id.present?
            patient.appointments.find(built_from_appointment_id)
          end
        end
      end

      def build_clinic_visit
        class_for_new_visit.new(params.merge(patient: patient))
      end

      # A Clinics::Clinic may hint the visit_class_name column which specific class name should be
      # instantiated when creating a new Visit. If blank then it is just a vanilla Visit.
      def class_for_new_visit
        return Clinics::ClinicVisit if clinic&.visit_class_name.blank?

        @class_for_new_visit ||= Class.const_get(clinic.visit_class_name.classify)
      end

      def clinic
        @clinic ||= Clinic.find_by(id: params[:clinic_id])
      end

      attr_reader :params, :patient, :built_from_appointment_id
    end
  end
end
