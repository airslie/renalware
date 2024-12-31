# A Liquid 'Drop' - a safe, read-only presenter compatible with Liquid templates.
# We use Liquid templates for one-off hospital-specific views or print-outs.

module Renalware
  module Patients
    class PatientDrop < Liquid::Drop
      delegate :given_name,
               :family_name,
               :telephone1,
               :telephone2,
               to: :patient

      def initialize(patient)
        @patient = patient
      end

      def born_on
        I18n.l(patient.born_on)
      end

      def hospital_identifier
        patient.hospital_identifier&.to_s
      end

      def name
        patient.to_s(:default)
      end

      def current_modality
        patient.current_modality&.to_s
      end

      def diabetic
        patient.diabetic? ? "Yes" : "No"
      end

      private

      attr_reader :patient
    end
  end
end
