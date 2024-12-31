module Renalware
  module Transplants
    class RecipientFollowupsController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility

      def show
        followup = operation.followup
        authorize followup
        render locals: { patient: transplants_patient, recipient_followup: followup }
      end

      def new
        render_new(operation.build_followup)
      end

      def edit
        render_edit(operation.followup)
      end

      def create
        followup = copy_attributes_onto_followup(operation.build_followup)
        authorize followup
        if followup.save
          redirect_to patient_transplants_recipient_dashboard_path(transplants_patient),
                      notice: success_msg_for("recipient follow up")
        else
          flash.now[:error] = failed_msg_for("recipient follow up")
          render_new(followup)
        end
      end

      def update
        followup = copy_attributes_onto_followup(operation.followup)
        authorize followup
        if followup.save
          redirect_to patient_transplants_recipient_dashboard_path(transplants_patient),
                      notice: success_msg_for("recipient follow up")
        else
          flash.now[:error] = failed_msg_for("recipient follow up")
          render_edit(followup)
        end
      end

      protected

      def copy_attributes_onto_followup(followup)
        followup.attributes = followup_attributes
        followup.rejection_episodes.each do |episode|
          episode.by = current_user
        end
        followup
      end

      def render_new(followup)
        authorize followup
        render(
          :new,
          locals: {
            patient: transplants_patient,
            recipient_followup: followup
          }
        )
      end

      def render_edit(followup)
        authorize followup
        render(
          :edit,
          locals: {
            patient: transplants_patient,
            recipient_followup: followup
          }
        )
      end

      def operation
        @operation ||= RecipientOperation.find(params[:recipient_operation_id])
      end

      def followup_attributes
        params
          .require(:transplants_recipient_followup)
          .permit(attributes)
          .merge(document: document_attributes)
      end

      def attributes
        [
          :notes,
          :stent_removed_on,
          :transplant_failed,
          :transplant_failed_on,
          :transplant_failure_cause_description_id,
          :transplant_failure_cause_other,
          :transplant_failure_notes,
          :graft_nephrectomy_on,
          :graft_function_onset,
          :last_post_transplant_dialysis_on,
          :return_to_regular_dialysis_on,
          rejection_episodes_attributes: [
            :id,
            :recorded_on,
            :notes,
            :treatment_id,
            :created_at,
            :updated_at,
            :created_by_id,
            :updated_by_id,
            :_destroy
          ],
          document: []
        ]
      end

      def document_attributes
        params
          .require(:transplants_recipient_followup)
          .fetch(:document, nil)
          .try(:permit!)
      end
    end
  end
end
