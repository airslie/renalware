module Renalware
  module Letters
    class FormattedLettersController < Letters::BaseController
      before_action :load_patient

      layout "renalware/layouts/letter"

      def show
        letter = find_letter(params[:letter_id])
        letter = present_letter(letter)

        respond_to do |format|
          format.html { render locals: { letter: letter } }
          format.pdf  { render_pdf(letter) }
          format.rtf  { render_rtf(letter) }
        end
      end

      private

      def find_letter(id)
        @patient.letters
          .with_patient
          .with_main_recipient
          .with_cc_recipients
          .find(id)
      end

      def present_letter(letter)
        LetterPresenterFactory.new(letter)
      end

      # Here we are just printing an adhoc letter for manual stuffing so we pass in
      # an argument to prompt adhoc CSS to be included so for example the CCs at the bottom of the
      # letter will render with more padding. See LetterPresenter
      def render_pdf(letter)
        renderer = RendererFactory.renderer_for(letter, :pdf, adhoc_printing: true)
        send_data(
          renderer.call,
          filename: letter.pdf_filename,
          type: "application/pdf",
          disposition: disposition
        )
      end

      def render_rtf(letter)
        renderer = RendererFactory.renderer_for(letter, :rtf)
        send_data renderer.call,
                  type: "text/richtext",
                  filename: renderer.filename,
                  disposition: disposition
      end

      def disposition
        params.fetch("disposition", "attachment")
      end
    end
  end
end
