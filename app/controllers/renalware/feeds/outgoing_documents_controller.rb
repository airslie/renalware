module Renalware
  module Feeds
    class OutgoingDocumentsController < BaseController
      include Pagy::Backend

      def index
        query = OutgoingDocument
          .includes(:created_by)
          .ransack(params.fetch(:q, { s: "created_at desc" }))
        pagy, documents = pagy(query.result)
        authorize documents
        render locals: { documents: documents, pagy: pagy, query: query }
      end
    end
  end
end
