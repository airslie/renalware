# frozen_string_literal: true

module Renalware
  module HD
    class PatientListener
      # Listens for this message!
      def patient_modality_changed_to_death(args)
        deactivate_current_hd_profile_for(args[:patient])
      end

      # Listens for this message!
      def request_default_electronic_cc_recipients_for_use_in_letters(args)
        array_of_user_ids = args[:array_of_user_ids]
        patient = HD.cast_patient(args[:patient])
        if patient.current_modality_hd?
          named_nurse_id = patient.named_nurse&.id
          array_of_user_ids.push(named_nurse_id) if named_nurse_id.present?
        end
      end

      private

      def deactivate_current_hd_profile_for(patient)
        HD.cast_patient(patient).hd_profile&.delete
      end
    end
  end
end
