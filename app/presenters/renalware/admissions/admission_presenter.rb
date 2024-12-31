module Renalware
  module Admissions
    class AdmissionPresenter < SimpleDelegator
      delegate :nhs_number,
               :hospital_identifiers,
               :age,
               :sex,
               :current_modality,
               to: :patient,
               prefix: true,
               allow_nil: true

      def patient
        @patient ||= Renalware::PatientPresenter.new(__getobj__.patient)
      end

      def unit_and_ward
        ward = hospital_ward || NullObject.instance
        [
          ward.hospital_unit.unit_code,
          [ward.name, ward.code].reject.first
        ].compact.join(" / ")
      end

      def patient_name
        __getobj__.patient&.to_s
      end

      # Returns elapsed days as an integer
      def length_of_stay
        return 0 if admitted_on.blank?
        return length_of_stay_if_discharged if discharged_on.present?

        length_of_stay_if_currently_admitted
      end

      private

      def length_of_stay_if_currently_admitted
        (Time.zone.now.to_date - admitted_on.to_date).to_i
      end

      def length_of_stay_if_discharged
        (discharged_on.to_date - admitted_on.to_date).to_i
      end
    end
  end
end
