module World
  module PD::Regime
    module Domain
      def regime_for_patient_is_current(patient:, regime:)
        expect(regime).to be_current
      end
    end

    module Web
      include Domain

      def regime_for_patient_is_current(patient:, regime:)
        visit patient_pd_dashboard_path(patient)

        expect(find(".current-regime")["data-regime-id"].to_i).to eq(regime.id)
      end
    end
  end
end
