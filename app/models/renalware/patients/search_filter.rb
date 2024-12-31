# Works in concert with Patients::SearchQuery and Patients::SearchForm.
# Example usage in a controller:
#
#   my_relation = Thing.all.joins(:patient)
#   filter = Patients::SearchFilter.new(search_term, request)
#   my_relation = patient_filter.call(my_relation)
#   render locals: { search_form: filter.search_form }

module Renalware
  module Patients
    class SearchFilter
      attr_reader :search_form

      def initialize(search_term, request)
        @search_form = build_search_form(search_term, request)
      end

      def call(relation)
        matching_patients = Patients::SearchQuery.new(term: search_form.term).call
        relation.merge(matching_patients)
      end

      def build_search_form(search_term, request)
        Patients::SearchForm.new(
          term: search_term,
          url: request.path
        )
      end
    end
  end
end
