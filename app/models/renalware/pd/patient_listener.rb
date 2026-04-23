module Renalware
  module PD
    class PatientListener
      def patient_modality_changed_from_pd(args)
        return if args[:modality].description.to_sym == :pd

        current_regime_for(args[:patient])&.tap do |regime|
          terminated_on = args[:modality].started_on.to_date
          regime.end_date ||= terminated_on
          regime.terminate(by: args[:actor], terminated_on:)
          regime.save!
        end
      end

      private

      def current_regime_for(patient)
        patient.pd_regimes.current.first
      end
    end
  end
end
