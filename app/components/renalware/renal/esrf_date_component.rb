module Renalware
  module Renal
    # Encapsulates the UI display of a patient's ESRF date for example in the
    # mini profile at the top of patient pages.
    # If the patient has a current modality in the specified set then always
    # display the ESRF: label and the esrf_on date, but if the date is missing
    # then add a css class to make e.g. red, so that it becomes a 'nag'.
    # If the patient has any other modality, only display the ESRF if one is
    # present.
    class ESRFDateComponent < ApplicationComponent
      rattr_initialize [:patient!]
      MODALITY_CODES_REQUIRING_AN_ESRF_DATE = %w(pd hd transplant).freeze

      def render?
        patient_should_have_an_esrf_date? || esrf_on.present?
      end

      def value
        esrf_on.present? ? I18n.l(esrf_on) : "Missing"
      end

      def css_class
        esrf_on.present? ? nil : "patient-missing-data"
      end

      def esrf_on
        @esrf_on ||= Renal.cast_patient(patient)&.profile&.esrf_on
      end

      def modality_code
        @modality_code ||= patient.current_modality&.description&.code
      end

      def patient_should_have_an_esrf_date?
        MODALITY_CODES_REQUIRING_AN_ESRF_DATE.include?(modality_code)
      end
    end
  end
end
