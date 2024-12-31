module Renalware
  module Patients
    class BroadcastPatientAddedEvent
      include Broadcasting

      def self.call(patient, reason = "")
        new
          .broadcasting_to_configured_subscribers
          .call(patient, reason)
      end

      def call(patient, reason)
        broadcast(:patient_added, patient, reason)
      end
    end
  end
end
