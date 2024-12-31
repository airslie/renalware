require "success"
require "failure"

module Renalware
  module PD
    class CreateRegime
      def initialize(patient:)
        @patient = patient
      end

      def call(by:, params:)
        regime = patient.pd_regimes.new(params)
        if regime.valid? && save_regime(regime, by)
          ::Success.new(regime)
        else
          ::Failure.new(regime)
        end
      end

      private

      attr_reader :patient

      def save_regime(new_regime, by)
        Regime.transaction do
          if update_old_regime_end_date?(current_regime, new_regime)
            current_regime.end_date ||= new_regime.start_date
          end
          current_regime.terminate(by: by).save && new_regime.save_by(by)
        end
      end

      def update_old_regime_end_date?(old_regime, new_regime)
        # This odd .to_time.to_i stuff is to get around a stack overflow recursion
        # error when running rspec unit tests!
        new_regime.start_date.to_time.to_i >= old_regime.start_date.to_time.to_i
      end

      def current_regime
        @current_regime ||= patient.pd_regimes.current || NullObject.instance
      end
    end
  end
end
