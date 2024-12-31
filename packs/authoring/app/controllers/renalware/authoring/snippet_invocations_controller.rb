module Renalware
  module Authoring
    class SnippetInvocationsController < BaseController
      # Note we need to skip CSRF validation via protect_from_forgery here,
      # otherwise the JS fetch POST gets a 401 and the user is logged out.
      protect_from_forgery unless: -> { request.format.json? }

      # Whenever a snippet is inserted somewhere, a new invocation is conceptually 'created'
      # (actually we just update the usage count on the snippet record).
      # This is done from a POST fetch call in the stimulus SnippetsController.
      # The invocation url is defined as a data attribute by each instance of the (singular)
      # stimulus SnippetController that is attached to each row in the table in the snippets dialog.
      # It sends the url to the overarching SnippetsController outlet, along with the snippet text,
      # when the Insert button on that row is clicked.
      def create
        skip_authorization
        snippet = Snippet.find(params[:snippet_id])
        snippet.record_usage
        render json: { result: "ok" }
      end
    end
  end
end
