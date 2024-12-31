module Renalware
  module Clinics
    class BuildVisitFromAppointment
      def initialize(appointment)
        @appointment = appointment
      end

      def call(opts = {})
        visit = clinic_visit_class.new(opts)
        visit.patient = appointment.patient
        visit.clinic = appointment.clinic
        starts_at = appointment.starts_at
        visit.date = starts_at.to_date
        visit.time = starts_at
        visit
      end

      private

      attr_reader :appointment

      def clinic_visit_class
        return ClinicVisit if appointment.clinic.visit_class_name.blank?

        appointment.clinic.visit_class_name.constantize
      end
    end
  end
end
