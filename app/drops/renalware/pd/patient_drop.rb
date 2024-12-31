# A Liquid 'Drop' - a safe, read-only presenter compatible with Liquid templates.
# We use Liquid templates for one-off hospital-specific views or print-outs.

module Renalware
  module PD
    class PatientDrop < Liquid::Drop
      def initialize(patient)
        @patient = PD.cast_patient(patient)
      end

      def exit_site_infections
        patient.exit_site_infections.map { |esi| ExitSiteInfectionDrop.new(esi) }
      end

      private

      attr_reader :patient
    end
  end
end
