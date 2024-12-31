module Renalware
  module Letters
    class ApprovedLettersController < Letters::BaseController
      before_action :load_patient

      def create
        letter = @patient.letters.pending_review.find(params[:letter_id])

        # See config.broadcast_subscription_map for ApproveLetter event subscribers
        # We use an event subscription pattern to drive the delivery of letters at this point
        # rather than hard-wiring in a call to DeliverLetter.call etc. This is because letter
        # delivery is hospital-specific, and each might want to plumb in different or many classes
        # to handle different aspects of letter processing - not just delivery but also EPR etc.
        ApproveLetter
          .build(letter)
          .broadcasting_to_configured_subscribers
          .call(by: current_user)

        redirect_to patient_clinical_summary_path(@patient), notice: t(".success")
      end
    end
  end
end
