module Renalware
  module Letters::Transports::Mesh
    class OperationsController < BaseController
      include Pagy::Backend
      layout -> { turbo_frame_request? ? "turbo_rails/frame" : "renalware/layouts/admin" }

      def index
        authorize Operation, :index?
        search = Operation
          .order(created_at: :desc)
          .ransack(params.fetch(:q, {}))
        pagy, operations = pagy(search.result)
        authorize operations
        render locals: { operations: operations, pagy: pagy, search: search }
      end

      def show
        operation = Operation.find(params[:id])
        authorize operation
        render locals: { operation: operation }
      end

      def check_inbox
        authorize Operation, :check_inbox?
        CheckInboxJob.perform_later
        head :ok
      end

      def handshake
        authorize Operation, :handshake?
        HandshakeJob.perform_later
        head :ok
      end

      # rubocop:disable Metrics/MethodLength
      def preview_reconstituted_letter
        authorize Operation, :show?
        operation = Operation.find(params[:id])

        if operation.action.to_sym != :send_message
          raise ArgumentError, "operation action must be :send_message"
        end

        # Our XML contains an root 'message' Bundle with a nested 'focus' 'document' Bundle.
        # The XSLT expects to find the document Bundle as the first element in the document, so
        # here get an in-memory copy of the document Bundle, remove the root message Bundle
        # from the document, and then add the document Bundle in as the root element. Simples. Not.
        doc = Nokogiri::XML(operation.payload)
        document_bundle = doc.xpath("//fhir:Bundle", fhir: "http://hl7.org/fhir").last
        doc.xpath("//fhir:Bundle", fhir: "http://hl7.org/fhir").remove
        doc.add_child(document_bundle)

        xslt_path = Renalware::Engine.root.join("vendor/xslt/transfer_of_care/DocumentToHTML.xslt")
        xslt = Nokogiri::XSLT(File.read(xslt_path))
        html = xslt.transform(doc)
        render locals: { html: html }, layout: nil
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
