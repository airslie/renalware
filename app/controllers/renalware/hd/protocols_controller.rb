module Renalware
  module HD
    # Responsible for rendering an HD Session Form PDF (aka Protocol) which has the patients
    # past 3 sessions on it, and empty rows for their next three sessions.
    class ProtocolsController < BaseController
      # Note that although rendering an individual PDF for a patient here, we use PdfRender
      # which can handles multiple patients, and hence it uses the index.pdf.slim view.
      # The show view is not used.
      def show
        authorize Session, :show?
        respond_to do |format|
          format.html { render html: pdf_renderer.call }
          format.pdf { send_pdf_data_as_inline_file }
        end
      end

      private

      def send_pdf_data_as_inline_file
        send_data(
          pdf_renderer.call,
          filename: pdf_filename,
          type: "application/pdf",
          disposition: "inline"
        )
      end

      def pdf_renderer
        @pdf_renderer ||= SessionForms::PdfRenderer.new(
          patients: patient,
          output_html_for_debugging: params.key?(:debug)
        )
      end

      def pdf_filename
        "#{patient.family_name}-#{patient.hospital_identifier.id}-protocol".upcase + ".pdf"
      end
    end
  end
end
