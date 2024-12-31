module Renalware
  module Transplants
    class DonationsController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility

      def show
        donation = Donation.for_patient(transplants_patient).find(params[:id])
        authorize donation
        render locals: { patient: transplants_patient, donation: donation }
      end

      def new
        donation = Donation.new
        authorize donation
        render_new(donation)
      end

      def edit
        render_edit(find_and_authorise_donation)
      end

      def create
        donation = Donation.new(patient: transplants_patient)
        donation.attributes = donation_params
        authorize donation

        if donation.save
          redirect_to patient_transplants_donor_dashboard_path(transplants_patient),
                      notice: success_msg_for("donation")
        else
          flash.now[:error] = failed_msg_for("donation")
          render_new(donation)
        end
      end

      def update
        donation = find_and_authorise_donation
        donation.attributes = donation_params

        if donation.save
          redirect_to patient_transplants_donor_dashboard_path(transplants_patient),
                      notice: success_msg_for("donation")
        else
          flash.now[:error] = failed_msg_for("donation")
          render_edit(donation)
        end
      end

      private

      def find_and_authorise_donation
        Donation
          .for_patient(transplants_patient)
          .find(params[:id])
          .tap { |donation| authorize donation }
      end

      def render_new(donation)
        render :new, locals: { patient: transplants_patient, donation: donation }
      end

      def render_edit(donation)
        render :edit, locals: { patient: transplants_patient, donation: donation }
      end

      def donation_params
        params.require(:transplants_donation).permit(attributes)
      end

      def attributes
        %i(
          state
          recipient_id
          relationship_with_recipient
          relationship_with_recipient_other
          blood_group_compatibility
          mismatch_grade
          paired_pooled_donation
          volunteered_on
          first_seen_on
          workup_completed_on
          donated_on
          notes
        )
      end
    end
  end
end
