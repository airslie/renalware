module Renalware
  module Letters
    class RejectedLettersController < Letters::BaseController
      def create
        letter = patient.letters.pending.find(params[:letter_id])
        authorize letter
        draft_letter = letter.reject(by: current_user)
        draft_letter.save!

        redirect_to patient_letters_letter_path(patient, draft_letter), notice: t(".success")
      end
    end
  end
end
