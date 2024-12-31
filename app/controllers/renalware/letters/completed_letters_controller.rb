module Renalware
  module Letters
    class CompletedLettersController < Letters::BaseController
      before_action :load_patient

      # HTML GET for insertion into modal dialog
      def new
        render layout: false, locals: {
          letter: letter
        }
      end

      def create
        CompleteLetter.build(letter).call(by: current_user)

        respond_to do |format|
          format.html do
            redirect_to patient_letters_letter_path(@patient, letter), notice: t(".success")
          end
          format.js do
            render locals: { letter: letter }
          end
        end
      end

      private

      def letter
        @letter ||= @patient.letters.approved.find(params[:letter_id])
      end
    end
  end
end
