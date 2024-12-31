module Renalware
  module Letters
    class PendingReviewLettersController < Letters::BaseController
      before_action :load_patient

      def create
        letter = @patient.letters.draft.find(params[:letter_id])
        letter_pending_review = letter.submit(by: current_user)
        letter_pending_review.save!

        redirect_to patient_letters_letter_path(@patient, letter_pending_review),
                    notice: t(".success")
      end
    end
  end
end
