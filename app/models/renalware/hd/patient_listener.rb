# frozen_string_literal: true

module Renalware
  module HD
    class PatientListener
      # Listens for this message
      def patient_modality_changed_to_death(args)
        supersede_old_hd_profile_with_new_one_with_nulled_attributes(
          args[:patient],
          by: args[:actor]
        )
      end

      # Listens for this message
      def request_default_electronic_cc_recipients_for_use_in_letters(args)
        array_of_user_ids = args[:array_of_user_ids]
        patient = HD.cast_patient(args[:patient])
        if patient.current_modality_hd?
          named_nurse_id = patient.named_nurse&.id
          array_of_user_ids.push(named_nurse_id) if named_nurse_id.present?
        end
      end

      private

      def supersede_old_hd_profile_with_new_one_with_nulled_attributes(patient, by:)
        profile = HD.cast_patient(patient).hd_profile
        return if profile.nil?

        ReviseHDProfile.new(profile).call(
          hospital_unit: nil,
          schedule_definition: nil,
          by: by
        )
      end
    end
  end
end
