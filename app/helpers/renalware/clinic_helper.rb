module Renalware
  module ClinicHelper
    # rubocop:disable Metrics/MethodLength
    def link_to_clinic_visit_letter(patient, clinic_visit)
      letter = Renalware::Letters::Letter.for_event(clinic_visit)
      if letter.present?
        link_to(
          "Preview Letter",
          patient_letters_letter_path(patient, letter),
          target: "_top"
        )
      else
        link_to(
          "Draft Letter",
          new_patient_letters_letter_path(
            patient,
            event_type: Renalware::Clinics::ClinicVisit.name.to_s,
            event_id: clinic_visit.id,
            clinical: true
          ),
          target: "_top"
        )
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
