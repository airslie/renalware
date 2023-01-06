# frozen_string_literal: true

module Renalware
  module Patients
    class ClearPatientUKRDCData
      pattr_initialize [:patient!, :by!]

      def self.call(**args)
        new(**args).call
      end

      # Note that we want to avoid any patient validation errors (email is invalid etc)
      # at this important stage, so we use validate: false. While we validate patient data
      # entered thorugh the UI, its possible that some migrated data might be invalid
      # and would cause an error to be raised during a callback in save!
      def call
        patient.send_to_rpv = false
        patient.rpv_decision_on = Time.zone.today
        patient.rpv_recorded_by = by.to_s
        patient.by = by
        patient.save!(validate: false)
      end
    end
  end
end
