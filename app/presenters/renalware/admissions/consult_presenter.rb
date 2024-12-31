module Renalware
  module Admissions
    class ConsultPresenter < SimpleDelegator
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

      def location
        [
          consult_site&.name,
          hospital_ward&.name,
          other_site_or_ward
        ].compact_blank.join(", ")
      end

      def patient_name
        __getobj__.patient&.to_s
      end
    end
  end
end
