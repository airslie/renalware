module Renalware
  module PD
    class PETResultsController < Renalware::BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility

      def index
        respond_to do |format|
          format.json do # Graphing data
            authorize PETResult, :index?
            render json: pet_graph_data
          end
          format.js do
            results = pd_patient.pet_results.ordered
            authorize results
            render locals: { results: results }
          end
        end
      end

      def new
        pet = PETResult.new(
          patient: pd_patient,
          performed_on: Date.current
        )
        authorize pet
        render_new(pet)
      end

      def edit
        render locals: { pet: find_authorize_pet_result }
      end

      def create
        pet = PETResult.new(pet_result_params)
        authorize pet

        if pet.save_by(current_user)
          redirect_to patient_pd_dashboard_path(pd_patient), notice: success_msg_for("PET result")
        else
          render_new(pet)
        end
      end

      def update
        pet = find_authorize_pet_result
        if pet.update_by(current_user, pet_result_params)
          redirect_to patient_pd_dashboard_path(pd_patient), notice: success_msg_for("PET result")
        else
          render_edit(pet)
        end
      end

      def destroy
        find_authorize_pet_result.destroy!
        redirect_to patient_pd_dashboard_path(pd_patient), notice: success_msg_for("Result")
      end

      private

      def pet_graph_data
        pd_patient
          .pet_results
          .where("d_pcr is not null and net_uf is not null")
          .order(performed_on: :asc)
          .pluck(:d_pcr, :net_uf)
      end

      def find_authorize_pet_result
        PD::PETResult.for_patient(pd_patient).find(params[:id]).tap do |pet|
          authorize pet
        end
      end

      def render_edit(pet)
        render :edit, locals: { pet: pet }
      end

      def render_new(pet)
        render :new, locals: { pet: pet }
      end

      def pet_result_params
        dialysate_sample_params = [0, 2, 4, 6].each_with_object([]) do |hr, arr|
          arr << :"sample_#{hr}hr_time"
          arr << :"sample_#{hr}hr_urea"
          arr << :"sample_#{hr}hr_creatinine"
          arr << :"sample_#{hr}hr_glc"
          arr << :"sample_#{hr}hr_sodium"
          arr << :"sample_#{hr}hr_protein"
        end

        params
          .require(:pd_pet_result)
          .permit(
            :patient_id,
            :performed_on,
            :test_type,
            :volume_in,
            :volume_out,
            :dextrose_concentration_id,
            :infusion_time,
            :drain_time,
            :overnight_volume_in,
            :overnight_volume_out,
            :overnight_dextrose_concentration_id,
            :overnight_dwell_time,
            :serum_time,
            :serum_urea,
            :serum_creatinine,
            :plasma_glc,
            :serum_ab,
            :serum_na,
            *dialysate_sample_params
          )
      end
    end
  end
end
