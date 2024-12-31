module Renalware
  module PD
    class RegimesController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility
      include Pagy::Backend

      def index
        pagy, regimes = pagy(
          regime_type_class.for_patient(pd_patient).with_bags.ordered
        )

        authorize regimes

        render locals: {
          patient: pd_patient,
          regimes: regimes,
          pd_type_string: pd_type_string,
          pagy: pagy
        }
      end

      def capd_regimes
        @capd_regimes ||= CAPDRegime.for_patient(pd_patient).with_bags.ordered.page(1).per(5)
      end

      def apd_regimes
        @apd_regimes ||= APDRegime.for_patient(pd_patient).with_bags.ordered.page(1).per(5)
      end

      def show
        render :show, locals: {
          regime: pd_regime,
          patient: pd_patient
        }
      end

      def new
        regime = cloned_last_known_regime_of_type || pd_patient.pd_regimes.new(type: regime_type)
        authorize regime
        render_new(regime)
      end

      def edit
        render_edit(pd_regime)
      end

      def create
        authorize Regime, :create?
        result = CreateRegime
          .new(patient: pd_patient)
          .call(by: current_user, params: pd_regime_params)

        if result.success?
          redirect_to patient_pd_dashboard_path(pd_patient), notice: success_msg_for("PD regime")
        else
          flash.now[:error] = failed_msg_for("PD Regime")
          render_new(result.object)
        end
      end

      def update
        result = ReviseRegime.new(pd_regime).call(by: current_user, params: pd_regime_params)

        if result.success?
          redirect_to patient_pd_dashboard_path(pd_patient),
                      notice: success_msg_for("PD regime")
        else
          flash.now[:error] = failed_msg_for("PD regime")
          render_edit(result.object)
        end
      end

      private

      def render_edit(regime)
        render :edit, locals: { regime: regime, patient: pd_patient }
      end

      def render_new(regime)
        render :new, locals: { regime: regime, patient: pd_patient }
      end

      def regime_type
        params[:type] ? "Renalware::#{params[:type]}" : nil
      end

      def regime_type_class
        @regime_type_class ||= regime_type.constantize
      end

      def pd_type_string
        regime_type_class.new.pd_type.upcase # CAPD or APD
      end

      def cloned_last_known_regime_of_type
        regime = patient
          .pd_regimes
          .order(start_date: :desc, created_at: :desc)
          .where(type: regime_type).first
        regime&.start_date = Time.zone.today
        regime&.deep_dup
      end

      def pd_regime_params
        params.require(:pd_regime).permit(
          :start_date, :end_date, :treatment, :assistance_type, :type,
          :add_hd, :tidal_full_drain_every_three_cycles,
          :tidal_indicator, :tidal_percentage, :no_cycles_per_apd,
          :apd_machine_pac, :dwell_time, :therapy_time, :fill_volume, :delivery_interval,
          :system_id, :last_fill_volume, :additional_manual_exchange_volume,
          :exchanges_done_by, :exchanges_done_by_if_other, :exchanges_done_by_notes,
          bags_attributes: [
            :id, :regime_id, :bag_type_id, :volume, :role, :capd_overnight_bag, :per_week,
            :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday, :_destroy
          ]
        )
      end

      def pd_regime
        @pd_regime ||= Regime.find(params[:id]).tap { |reg| authorize reg }
      end
    end
  end
end
