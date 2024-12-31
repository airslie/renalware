module Renalware
  module Medications
    class PrescriptionPresenter < DumbDelegator
      delegate :drug_types, :code, to: :drug
      delegate :local_patient_id, :age, :sex, :current_modality, to: :patient, prefix: true

      def patient_name
        patient.to_s
      end

      def form_name
        form&.name
      end

      def patient_current_modality_name
        return unless patient_current_modality

        patient_current_modality.description.to_s
      end

      def route_code
        medication_route&.name
      end

      def drug_type_names
        drug_types.map(&:name).join(", ")
      end

      def provider
        ::I18n.t(super, scope: "enums.provider")
      end

      def dose
        unit = unit_of_measure.present? ? unit_of_measure.name : translated_dose_unit

        "#{dose_amount} #{unit}"
      end

      def frequency
        [
          Drugs::Frequency.title_for_name(__getobj__.frequency),
          frequency_comment
        ].compact.join(" ")
      end

      def administer_on_hd?
        administer_on_hd ? "Yes" : "No"
      end

      def stat?
        stat ? "Yes" : "No"
      end

      def to_s
        [
          drug_name,
          "DOSE #{dose}",
          route_code,
          frequency
        ].compact.join(" - ")
      end

      def provider_suffix
        case __getobj__.provider&.to_s
        when "gp" then "GP"
        when "hospital", "home_delivery" then "HOSP"
        end
      end

      def last_given_or_due_date_with_indicator
        return "#{::I18n.l(prescribed_on)} (D)" if administer_on_hd? && stat

        if last_administration_on_hd&.recorded_on.present?
          "#{::I18n.l(last_administration_on_hd.recorded_on)} (L)"
        end
      end

      private

      def last_administration_on_hd
        @last_administration_on_hd ||=
          HD::PrescriptionAdministrationsQuery.new(prescription: self).call.first
      end

      def translated_dose_unit
        return nil if dose_unit.nil?

        ::I18n.t(dose_unit, scope: "enumerize.renalware.medications.prescription.dose_unit")
      end
    end
  end
end
