module Renalware
  module HD
    module SessionForms
      # Renders 1 or more HD Protocols (Session Forms) to PDF. If > 1 patient
      class PdfRenderer
        def initialize(patients:, output_html_for_debugging: false)
          @patients = Array(patients)
          @output_html_for_debugging = output_html_for_debugging
        end

        def call
          return pdf_html if output_html_for_debugging?

          WickedPdf.new.pdf_from_string(pdf_html, pdf_options)
        end

        private

        attr_reader :patients, :output_html_for_debugging

        def pdf_html
          @pdf_html ||= begin
            # Note we don't actually hit the ProtocolController#index action here.
            controller.render_to_string(
              template: "renalware/hd/protocols/index",
              layout: "renalware/layouts/pdf",
              locals: {
                protocols: protocols_to_render,
                host: "localhost"
              }
            )
          end
        end

        def controller
          @controller ||= MyController.new
        end

        def protocols_to_render
          patients.map { |pat| ProtocolPresenter.new(pat, controller.view_context) }
        end

        def pdf_options
          {
            page_size: "A4",
            orientation: "Landscape",
            layout: "renalware/layouts/pdf",
            print_media_type: true,
            margin: { top: 10, bottom: 10, left: 10, right: 10 },
            footer: {
              font_size: 8
            }
          }
        end

        def output_html_for_debugging?
          output_html_for_debugging == true
        end

        # Local ProtocolsController controller used for 'rendering anywhere'.
        # Using ProtocolsController here mainly to benefit from the view paths associated with it.
        class MyController < ProtocolsController
          def url_options
            {
              host: ENV.fetch("HOST", "localhost")
            }
          end
        end
      end
    end
  end
end
