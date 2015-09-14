module Renalware
  class PdRegimesController < BaseController
    include Renalware::Concerns::NestedActionsControllerMethods

    load_and_authorize_resource

    before_action :load_patient
    before_action :find_pd_regime, only: [:edit, :update, :show]

    def new
      regime_type = params[:type] ? "Renalware::#{params[:type]}" : nil
      @pd_regime = PdRegime.new(patient: @patient, type: regime_type)
    end

    def create
      @pd_regime = PdRegime.new(pd_regime_params)
      if perform_action(pd_regime_bags, Proc.new { @pd_regime.save }, pd_regime: @pd_regime)
        redirect_to pd_info_patient_path(@patient), notice: "You have successfully added a PD Regime."
      else
        render :new
      end
    end

    def update
      if perform_action(pd_regime_bags, Proc.new { @pd_regime.update(pd_regime_params) }, pd_regime: @pd_regime)
        redirect_to pd_info_patient_path(@patient), notice: "You have successfully updated a PD Regime."
      else
        render :edit
      end
    end

    private

    def pd_regime_params
      params.require(:pd_regime).permit(:patient_id, :start_date, :end_date,
        :treatment, :type, :glucose_ml_percent_1_36, :glucose_ml_percent_2_27, :glucose_ml_percent_3_86,
        :amino_acid_ml, :icodextrin_ml, :low_glucose_degradation, :low_sodium, :add_hd, :last_fill_ml,
        :add_manual_exchange, :tidal_indicator, :tidal_percentage, :no_cycles_per_apd, :overnight_pd_ml,
        pd_regime_bags_attributes: [:id, :pd_regime_id, :bag_type_id, :volume, :per_week, :monday, :tuesday,
                                    :wednesday, :thursday, :friday, :saturday, :sunday, :_destroy])
    end

    def find_pd_regime
      @pd_regime = PdRegime.find(params[:id])
    end

    def pd_regime_bags
      @pd_regime.pd_regime_bags
    end
  end
end
