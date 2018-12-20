# frozen_string_literal: true

require_dependency "renalware/renal"

module Renalware
  module Renal
    module PRDDescriptions
      class SearchQuery
        attr_reader :term, :page, :per_page

        def initialize(term:, page: 1, per_page: 50)
          @term = term
          @page = page
          @per_page = per_page
        end

        def call
          search.result.page(page).per(per_page).select(fields)
        end

        private

        def search
          @search ||= PRDDescription.ransack(term_or_code_cont: term).tap do |s|
            s.sorts = ["term"]
          end
        end

        def fields
          %i(id code term)
        end
      end
    end
  end
end
