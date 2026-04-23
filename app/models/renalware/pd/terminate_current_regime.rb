module Renalware
  module PD
    class TerminateCurrentRegime
      def initialize(patient:)
        @patient = patient
      end

      def call(by:, terminated_on:)
        current_regime&.tap do |regime|
          regime.end_date ||= terminated_on
          regime.terminate(by:, terminated_on:)
          regime.save!
        end
      end

      private

      attr_reader :patient

      def current_regime
        patient.pd_regimes.current_one
      end
    end
  end
end
