module Renalware
  module Clinical
    class AllergyStatusForm
      include ActiveModel::Model
      include Virtus::Model

      attribute :no_known_allergies, Integer

      def save(patient, user)
        return unless patient.allergies.count.zero?

        patient.allergy_status = no_known_allergies? ? :no_known_allergies : :unrecorded
        patient.by = user
        patient.allergy_status_updated_at = Time.zone.now
        patient.save!
      end

      private

      def no_known_allergies?
        no_known_allergies == 1
      end
    end
  end
end
