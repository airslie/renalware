module Renalware
  module HD
    class PatientPresenter < SimpleDelegator
      # delegate_missing_to :patient # TODO: when rails 5.1, try instead of SimpleDelegator
      delegate :document, to: :hd_profile
      delegate :hospital_unit,
               :schedule_definition,
               :transport_summary,
               to: :hd_profile, allow_nil: true
      delegate :unit_code, to: :hospital_unit, allow_nil: true, prefix: true
      delegate :transport, to: :document
      delegate :type, to: :transport, prefix: true
      alias dialysing_at_unit hospital_unit_unit_code

      def initialize(patient)
        # If patient is already a presenter then use __getobj__ to access the model
        pat = patient.respond_to?(:__getobj__) ? patient.__getobj__ : patient
        super(HD.cast_patient(pat))
      end

      def finished_hd_sessions
        # TODO: standardise on a way to get closed sessions - a scope on patient maybe?
        hd_sessions.eager_load(:hospital_unit).where(type: "Renalware::HD::Session::Closed")
      end

      def current_observation_set
        @current_observation_set ||= begin
          Renalware::Pathology::ObservationSetPresenter.new(__getobj__.current_observation_set)
        end
      end

      private

      def hd_profile
        @hd_profile ||= HD::ProfilePresenter.new(__getobj__.hd_profile) || NullObject.instance
      end
    end
  end
end
