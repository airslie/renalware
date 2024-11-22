# frozen_string_literal: true

module Renalware
  module Authoring
    class DuplicateSnippetTitleGenerator
      MAX_ATTEMPTS = 100

      attr_reader :snippet, :title_suffix

      delegate :valid?, to: :snippet

      def initialize(snippet, title_suffix: "[CLONED]")
        @snippet = snippet
        @title_suffix = title_suffix
      end

      def call
        create_unique_title_for_cloned_snippet
      end

      private

      # The snippet may have been cloned before so the title e.g. "Some title [CLONED]" may have
      # been taken. In this case keep adding numbers on to the end e.g. "Some title [CLONED] (1)"
      # until we find a unique title.
      def create_unique_title_for_cloned_snippet
        original_title = snippet.title.dup
        while_conserving_original_title do
          (0..MAX_ATTEMPTS).each do |attempt|
            snippet.title = build_snippet_title(original_title, attempt)
            break if valid?
          end
          report_error unless valid?
        end
      end

      def while_conserving_original_title
        original_title = snippet.title
        yield
        new_title = snippet.title
        snippet.title = original_title
        new_title
      end

      def build_snippet_title(original_title, current_attempt_number = 0)
        title = "#{original_title} #{title_suffix}"
        title += " (#{current_attempt_number})" if current_attempt_number > 0
        title
      end

      class InvalidSnippetTitleError < ::StandardError
      end

      def report_error
        raise InvalidSnippetTitleError,
              "Tried #{MAX_ATTEMPTS} times to construct a new snippet title. Got to " \
              "'#{snippet.title}' but the title is still not unique."
      end
    end
  end
end
