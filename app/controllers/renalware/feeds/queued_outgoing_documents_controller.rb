module Renalware
  module Feeds
    class QueuedOutgoingDocumentsController < API::TokenAuthenticatedAPIController
      skip_before_action :track_ahoy_visit
      protect_from_forgery only: []
      after_action :track_action, only: []

      # Renders a JSON array of documents queued to be processed by Mirth. Mirth will query this
      # endpoint and for each item call #show
      def index
        documents = OutgoingDocument.queued_for_processing
        render json: {
          documents: documents.map { |doc| document_json(doc) }
        }
      end

      # Called by Mirth, renders json containing the HL7 document to be enqueued in Mirth.
      def show
        document = OutgoingDocument.queued_for_processing.find(params[:id])

        render json: {
          id: document.id,
          state: document.state,
          body: renderable(document)
        }
      end

      def update
        document = OutgoingDocument.queued_for_processing.find(params[:id])
        document.update!(state: :processed, by: current_user)

        render json: {
          result: "OK"
        }
      end

      private

      def document_json(document)
        protocol = Rails.env.local? || ENV.fetch("HTTP_ONLY_LINKS_IN_JSON", false) ? :http : :https
        {
          id: document.id,
          state: document.state,
          url: feeds_queued_outgoing_document_url(document, protocol: protocol, format: :json)
        }
      end

      def renderable(document)
        renderable = document.renderable

        if renderable.class.name.at("Events::")
          renderable = Events::EventPdfPresenter.new(renderable)
        end

        HL7DocumentMessageBuilder.call(renderable: renderable, message_id: document.id).to_s + "\r"
      end
    end
  end
end
