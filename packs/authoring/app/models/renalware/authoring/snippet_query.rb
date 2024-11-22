# frozen_string_literal: true

module Renalware
  module Authoring
    class SnippetQuery
      attr_reader :author, :relation

      def initialize(author:, relation: nil)
        @relation = relation || Snippet.includes(:author).all
        @author = author
      end

      def call
        snippets
      end

      private

      def snippets
        if author.present?
          relation.where(author_id: author.id)
        else
          relation.all
        end
      end
    end
  end
end
