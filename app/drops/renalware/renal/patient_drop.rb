# A Liquid 'Drop' - a safe, read-only presenter compatible with Liquid templates.
# We use Liquid templates for one-off hospital-specific views or print-outs.

module Renalware
  module Renal
    class PatientDrop < Liquid::Drop
      def initialize(patient)
        @patient = Renal.cast_patient(patient)
      end

      def profile_prd_description
        patient.profile&.prd_description&.to_s
      end

      private

      attr_reader :patient
    end
  end
end
