module Renalware
  module Pathology
    class PatientRulesController < BaseController
      include Renalware::Concerns::PatientVisibility
      include Renalware::Concerns::PatientCasting

      def new
        patient_rule = pathology_patient.rules.new
        authorize patient_rule

        render_new(patient_rule)
      end

      def edit
        render_edit(find_and_authorize_patient_rule)
      end

      def create
        patient_rule = pathology_patient.rules.new(patient_rule_params)
        authorize patient_rule

        if patient_rule.save
          redirect_to patient_pathology_required_observations_path(pathology_patient),
                      notice: success_msg_for("Patient Rule")
        else
          flash.now[:error] = failed_msg_for("Patient Rule")
          render_new(patient_rule)
        end
      end

      def update
        patient_rule = find_and_authorize_patient_rule

        if patient_rule.update(patient_rule_params)
          redirect_to patient_pathology_required_observations_path(pathology_patient),
                      notice: success_msg_for("patient rule")
        else
          flash.now[:error] = failed_msg_for("patient rule")
          render_edit(patient_rule)
        end
      end

      def destroy
        authorize Requests::PatientRule, :destroy?
        Requests::PatientRule.destroy(params[:id])

        redirect_to patient_pathology_required_observations_path(pathology_patient),
                    notice: success_msg_for("patient rule")
      end

      private

      def find_and_authorize_patient_rule
        pathology_patient.rules.find(params[:id]).tap { |rule| authorize rule }
      end

      def render_edit(patient_rule)
        render :edit, locals: {
          patient_rule: patient_rule,
          frequencies: find_frequencies,
          labs: find_labs
        }
      end

      def render_new(patient_rule)
        render :new, locals: {
          patient_rule: patient_rule,
          frequencies: find_frequencies,
          labs: find_labs
        }
      end

      def find_frequencies
        Requests::Frequency.all_names
      end

      def find_labs
        Lab.ordered
      end

      def patient_rule_params
        params
          .require(:pathology_requests_patient_rule)
          .permit(
            :patient_id,
            :lab_id,
            :test_description,
            :sample_number_bottles,
            :sample_type,
            :frequency_type,
            :start_date,
            :end_date
          )
      end
    end
  end
end
