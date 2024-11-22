# frozen_string_literal: true

module Renalware
  module Authoring
    class SnippetInvocationsController < BaseController
      def create
        snippet = Snippet.find(params[:snippet_id])
        authorize snippet
        snippet.record_usage
        respond_to do |format|
          format.js do
            render locals: { snippet: snippet }
          end
        end
      end
    end
  end
end
