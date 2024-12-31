module Renalware
  module Transplants
    class DonorFollowupsController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility

      def show
        authorize operation.followup
        render locals: {
          patient: transplants_patient,
          donor_followup: operation.followup
        }
      end

      def new
        donor_followup = operation.build_followup
        authorize donor_followup
        render_new(donor_followup)
      end

      def edit
        authorize operation.followup
        render_edit(operation.followup)
      end

      def create
        donor_followup = operation.build_followup
        donor_followup.attributes = followup_attributes
        authorize donor_followup

        if donor_followup.save
          redirect_to patient_transplants_donor_dashboard_path(transplants_patient)
        else
          render_new(donor_followup)
        end
      end

      def update
        authorize operation.followup
        donor_followup = operation.followup
        donor_followup.attributes = followup_attributes

        if donor_followup.save
          redirect_to patient_transplants_donor_dashboard_path(transplants_patient)
        else
          render_edit(operation.followup)
        end
      end

      protected

      def render_new(donor_followup)
        render :new, locals: { patient: transplants_patient, donor_followup: donor_followup }
      end

      def render_edit(donor_followup)
        render :edit, locals: { patient: transplants_patient, donor_followup: donor_followup }
      end

      def operation
        @operation ||= DonorOperation.find(params[:donor_operation_id])
      end

      def followup_attributes
        params
          .require(:transplants_donor_followup)
          .permit(attributes)
      end

      def attributes
        %i(
          notes
          last_seen_on
          followed_up
          ukt_center_code
          lost_to_followup
          transferred_for_followup
          dead_on
        )
      end
    end
  end
end
