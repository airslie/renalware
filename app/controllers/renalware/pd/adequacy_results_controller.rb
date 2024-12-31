module Renalware
  module PD
    class AdequacyResultsController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility

      def index
        respond_to do |format|
          format.js do
            results = pd_patient.adequacy_results.ordered
            authorize results
            render locals: { results: results }
          end
        end
      end

      def new
        adequacy = AdequacyResult.new(patient: pd_patient, performed_on: Date.current)
        authorize adequacy
        render locals: { adequacy: adequacy }
      end

      def edit
        adequacy = find_and_authorize_result
        # adequacy.derive_calculated_attributes
        render locals: { adequacy: adequacy }
      end

      def create
        adequacy = AdequacyResult.new(result_params)
        authorize adequacy

        if adequacy.save_by(current_user)
          redirect_to(
            patient_pd_dashboard_path(pd_patient),
            notice: success_msg_for("Adequacy result")
          )
        else
          render :new, locals: { adequacy: adequacy }
        end
      end

      def update
        result = find_and_authorize_result
        if result.update_by(current_user, result_params)
          redirect_to patient_pd_dashboard_path(pd_patient), notice: success_msg_for("Result")
        else
          render_edit(result)
        end
      end

      def destroy
        result = find_and_authorize_result
        result.destroy!
        redirect_to patient_pd_dashboard_path(pd_patient), notice: success_msg_for("Result")
      end

      private

      def find_and_authorize_result
        PD::AdequacyResult.for_patient(pd_patient).find(params[:id]).tap do |adequacy|
          authorize adequacy
        end
      end

      def render_edit(adequacy)
        render :edit, locals: { adequacy: adequacy }
      end

      def result_params
        params
          .require(:pd_adequacy_result)
          .permit(
            :patient_id,
            :performed_on,
            :height,
            :weight,
            :dial_24_vol_in,
            :dial_24_vol_out,
            :dial_24_missing,
            :urine_24_vol,
            :urine_24_missing,
            :dialysate_urea,
            :dialysate_creatinine,
            :dialysate_glu,
            :dialysate_na,
            :dialysate_protein,
            :urine_urea,
            :urine_creatinine,
            :urine_na,
            :urine_k,
            :serum_urea,
            :serum_creatinine
          )
      end
    end
  end
end
