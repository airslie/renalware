# frozen_string_literal: true

# Note this singular resource is for updating the patient.primary_care_physician.
# The plural resource in the same folder is for managing primary_care_physicians.
module Renalware
  module Patients
    class PrimaryCarePhysicianController < BaseController
      # We come in here when
      # 1. We render the Add GP modal form the first time (html)
      # 2. After a practice has been selected and we refresh the modal form so it has
      #    the correct list of GPs in it (js)
      def edit
        authorize patient
        render_form
      end

      def update
        authorize patient
        if update_patient
          redirect_to patient_path(patient), notice: "GP changed successfully"
        else
          flash[:error] = "The patient's GP was not changed"
          redirect_to patient_path(patient)
        end
      end

      def destroy
        authorize patient
        patient.update_by(current_user, primary_care_physician_id: nil, practice_id: nil)
        render locals: { patient: patient }
      end

      private

      # There maybe times (for instance after migration from a previous system) where the
      # patient is not `valid` (going into Demographics and just saving them would produce a
      # validation error) because for instance they have no Sex option selected. In these instances
      # if we tried to update the Practice and GP here using an `update` call, it would fail.
      # So to allow the Practice and GP to be assigned to such a patient we have to skip validation
      # callbacks by using update_columns.
      def update_patient
        patient.update_columns(
          primary_care_physician_id: selected_physician_id,
          practice_id: patient_params[:practice_id],
          updated_by_id: current_user.id
        )
      end

      def render_form
        render :edit, locals: locals, layout: false
      end

      def locals
        patient.practice_id = params[:practice_id]
        {
          patient: patient,
          available_primary_care_physicians: available_primary_care_physicians
        }
      end

      def selected_physician_id
        @selected_physician_id ||= PrimaryCarePhysician
          .select(:id)
          .find_by(id: patient_params[:primary_care_physician_id])
          &.id
      end

      def patient_params
        params.require(:patient).permit(:primary_care_physician_id, :practice_id)
      end

      # Every time a practice is selected from the autocomplete list in the Find GP modal
      # we re-render the edit form and inject the practice_id as a hidden field therein so it
      # is available in a form submission in the #update action.
      # The practice_id in this method is supplied here as a query param by the JS that refreshes
      # the form when a practice is selected - it will be the same as that posted in the form when
      # saved, but at this stage its ephemeral and just here to let us build the GP list to
      # render in the form.
      def available_primary_care_physicians
        practice_id = params[:practice_id]
        return [] unless practice_id

        find_practice_memberships_for(practice_id).map do |membership|
          [
            format_gp_name(membership),
            membership.primary_care_physician&.id
          ]
        end
      end

      # TODO: move to a query object
      def find_practice_memberships_for(practice_id)
        PracticeMembership
          .eager_load(:primary_care_physician)
          .where(practice_id: practice_id)
          .where("#{PrimaryCarePhysician.table_name}.deleted_at is NULL")
          .order(
            "#{PracticeMembership.table_name}.left_on desc," \
            "#{PrimaryCarePhysician.table_name}.name asc"
          )
      end

      def format_gp_name(membership)
        left_on = " (Left #{I18n.l(membership.left_on)})" if membership.left_on.present?
        "#{membership.primary_care_physician}#{left_on}"
      end
    end
  end
end
