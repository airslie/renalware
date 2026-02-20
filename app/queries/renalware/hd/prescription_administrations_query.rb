module Renalware
  module HD
    # Find the all PrescriptionAdministrations for a particular prescription
    class PrescriptionAdministrationsQuery
      pattr_initialize [:prescription!]
      delegate :patient, to: :prescription

      def self.call(prescription:, limit: 1)
        new(prescription: prescription).call(limit: limit)
      end

      def call(limit: 1)
        raise ArgumentError if prescription.blank?
        raise ArgumentError if patient.blank?

        hd_patient
          .prescription_administrations
          .where(prescription: prescription, administered: true)
          .order(recorded_on: :desc, created_at: :desc)
          .limit(limit)
      end

      private

      def hd_patient
        HD.cast_patient(patient)
      end
    end
  end
end
