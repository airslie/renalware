# frozen_string_literal: true

module Renalware
  module Medications
    class TerminateAllPatientPrescriptions
      attr_reader :patient, :by

      def self.call(patient:, by:)
        new(patient, by).call
      end

      def initialize(patient, by)
        @patient = patient
        @by = by
      end

      def call
        patient.prescriptions.current.each do |prescription|
          prescription.terminate(by: by).save!
        end
      end
    end
  end
end
