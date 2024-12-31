module Renalware
  module Letters
    class LetterFormPresenter < DumbDelegator
      def person_roles
        [].tap do |collection|
          if patient.primary_care_physician.present? && patient.practice.present?
            collection << primary_care_physician_role
          end
          collection << patient_role
          collection << other_role
        end
      end

      def patient
        PatientPresenter.new(super)
      end

      def primary_care_physician
        PrimaryCarePhysicianPresenter.new(patient.primary_care_physician)
      end

      def patient_cc_hint
        scope = "renalware.letters.hints.cc_hint"
        if patient.cc_on_all_letters
          ::I18n.t("cc_on_all_letters", scope: scope).html_safe
        else
          ::I18n.t("not_cc_on_all_letters", scope: scope).html_safe
        end
      end

      def cc_recipient_for_contact(contact)
        find_cc_recipient_for_contact(contact)
      end

      private

      def primary_care_physician_role
        label = "Primary Care Physician <address>#{primary_care_physician.name}, " \
                "#{patient.practice&.address}</address>".html_safe
        [label, "primary_care_physician", primary_care_physician.salutation]
      end

      def patient_role
        label = "Patient <address>#{patient.full_name}, #{patient.address}</address>".html_safe
        [label, "patient", patient.salutation]
      end

      def other_role
        ["Patient's Contact", "contact", ""]
      end
    end
  end
end
