require_dependency "renalware"

module Renalware
  module UKRDC
    class PatientPresenter < SimpleDelegator
      delegate :allergies, to: :clinical_patient
      delegate :clinic_visits, to: :clinics_patient

      def smoking_history
        @smoking_history ||= document.history&.smoking&.upcase
      end

      def letters
        CollectionPresenter.new(
          letters_patient.letters.approved,
          Renalware::Letters::LetterPresenterFactory
        )
      end

      def hospital_unit_code
        letter_head.site_code
      end

      private

      def clinical_patient
        @clinical_patient ||= Renalware::Clinical.cast_patient(__getobj__)
      end

      def clinics_patient
        @clinic_patient ||= Renalware::Clinics.cast_patient(__getobj__)
      end

      def letters_patient
        @letters_patient ||= Renalware::Letters.cast_patient(__getobj__)
      end
    end
  end
end