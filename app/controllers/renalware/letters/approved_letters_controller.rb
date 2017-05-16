require_dependency "renalware/letters"

module Renalware
  module Letters
    class ApprovedLettersController < Letters::BaseController
      before_action :load_patient

      def create
        letter = @patient.letters.pending_review.find(params[:letter_id])

        ApproveLetter.build(letter).call(by: current_user)

        redirect_to patient_clinical_summary_path(@patient), notice: t(".success")
      end
    end
  end
end
