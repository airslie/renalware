module Renalware
  module Transplants
    class WaitListRegistrationPresenter < SimpleDelegator
      delegate :uk_transplant_centre,
               :transplant,
               :organs,
               :crf,
               to: :document
      delegate :status,
               :status_updated_on,
               to: :uk_transplant_centre, prefix: true, allow_nil: true
      delegate :highest,
               :latest,
               to: :crf, prefix: true, allow_nil: true
      delegate :recorded_on,
               :result,
               to: :crf_highest, prefix: true, allow_nil: true
      delegate :recorded_on,
               :result,
               to: :crf_latest, prefix: true, allow_nil: true
      delegate :blood_group,
               :nb_of_previous_grafts,
               to: :transplant, prefix: true, allow_nil: true
      delegate :transplant_type,
               to: :organs,
               prefix: true, allow_nil: true
      delegate :hospital_identifier,
               :age,
               :sex,
               :current_modality,
               to: :patient,
               prefix: true, allow_nil: true

      def uk_transplant_centre_summary
        return if uk_transplant_centre_status.blank?

        "#{uk_transplant_centre_status} (#{I18n.l(uk_transplant_centre_status_updated_on)})"
      end

      def hd_hospital_unit_code
        Renalware::HD.cast_patient(patient).hd_profile&.hospital_unit&.unit_code
      end

      def esrf_date
        Renalware::Renal.cast_patient(patient).profile&.esrf_on
      end

      def dol
        entered_on && (Time.zone.today - entered_on).to_i
      end

      def sens
        return if crf_latest_result.blank?

        crf_latest_result.to_i > 60 ? "Sens" : "Unsens"
      end
    end
  end
end
