module Renalware
  module HD
    class PreferenceSetsController < BaseController
      include Renalware::Concerns::PatientVisibility
      include Renalware::Concerns::PatientCasting

      def edit
        preference_set = find_preference_set
        render locals: { patient: hd_patient, preference_set: preference_set }
      end

      def update
        preference_set = find_preference_set

        if preference_set.update(preference_set_params)
          redirect_to patient_hd_dashboard_path(hd_patient),
                      notice: success_msg_for("HD preferences")
        else
          flash.now[:error] = failed_msg_for("HD preferences")
          render :edit, locals: { patient: hd_patient, preference_set: preference_set }
        end
      end

      private

      def find_preference_set
        PreferenceSet.for_patient(hd_patient).first_or_initialize.tap { |ps| authorize ps }
      end

      def attributes
        [
          :schedule_definition_id, :other_schedule,
          :hospital_unit_id, :entered_on, :notes
        ]
      end

      def preference_set_params
        params
          .require(:hd_preference_set)
          .permit(attributes)
          .merge(by: current_user)
      end
    end
  end
end
