module Renalware
  module Transplants
    class PatientPresenter < SimpleDelegator
      def initialize(patient)
        patient = patient.__getobj__ if patient.respond_to?(:__getobj__)
        super(Transplants.cast_patient(patient))
      end

      def current_registration_status
        @current_registration_status ||= begin
          Transplants::Registration.for_patient(__getobj__).first&.current_status
        end
      end
    end
  end
end
