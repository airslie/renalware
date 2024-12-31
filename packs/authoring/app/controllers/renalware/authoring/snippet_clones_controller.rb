#
# This controller handles copying snippets (when I am the owner) and cloning them (when I am not).
# The ownership drives what suffix is appended to the snippet title to keep it unique.
#
module Renalware
  module Authoring
    class SnippetClonesController < BaseController
      COPY_SUFFIX = "[COPY]".freeze
      CLONE_SUFFIX = "[CLONE]".freeze

      def create
        snippet = duplicate_current_snippet
        authorize snippet
        snippet.save!
        redirect_to authoring.edit_snippet_path(snippet)
      end

      private

      def duplicate_current_snippet
        title_suffix = title_suffix_to_apply_to_the_duplicate(current_snippet)
        current_snippet.dup.tap do |snippet|
          snippet.author = Authoring.cast_user(current_user)
          snippet.title = snippet_title_generator_for(snippet, title_suffix: title_suffix).call
          snippet.last_used_on = nil
          snippet.times_used = 0
        end
      end

      def current_snippet
        Snippet.find(params[:snippet_id])
      end

      def title_suffix_to_apply_to_the_duplicate(snippet)
        snippet_is_mine?(snippet) ? COPY_SUFFIX : CLONE_SUFFIX
      end

      def snippet_title_generator_for(snippet, title_suffix:)
        DuplicateSnippetTitleGenerator.new(snippet, title_suffix: title_suffix)
      end

      def snippet_is_mine?(snippet)
        snippet.author_id == current_user.id
      end
    end
  end
end
