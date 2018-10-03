# frozen_string_literal: true

module Renalware
  module Accesses
    class PlansController < Accesses::BaseController
      def new
        plan = Plan.new
        authorize plan
        render_new(plan)
      end

      def create
        plan = patient.plans.new(plan_params.merge!(by: current_user))
        authorize plan
        if save_as_current(plan)
          redirect_to patient_accesses_dashboard_path(patient),
                      notice: success_msg_for("access plan")
        else
          render_new(plan)
        end
      end

      # Because editing a plan means creating a new current version (and terminating the previous
      # current one), we just render the new template using an instance of the current plan.
      def edit
        render_new(find_and_authorize_plan.dup)
      end

      def show
        render locals: {
          patient: patient,
          plan: find_and_authorize_plan
        }
      end

      private

      def find_and_authorize_plan
        plan = Plan.find(params[:id])
        authorize plan
        plan
      end

      def save_as_current(plan)
        Plan.transaction do
          if current_plan.present?
            return true if current_plan.identical_to?(plan) # no change, no new plan to be created

            current_plan.terminate_by(current_user)
          end
          plan.save!
        end
      rescue ActiveRecord::RecordInvalid
        false
      end

      def render_new(plan)
        render :new, locals: { patient: patient, plan: plan }
      end

      def render_edit(plan)
        render :edit, locals: { patient: patient, plan: plan }
      end

      def plan_params
        params.require(:accesses_plan).permit(:plan_type_id, :notes, :decided_by_id)
      end

      def current_plan
        @current_plan ||= patient.plans.current.first
      end
    end
  end
end
