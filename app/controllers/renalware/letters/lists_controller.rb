# frozen_string_literal: true

module Renalware
  module Letters
    class ListsController < Letters::BaseController
      include Renalware::Concerns::Pageable

      # rubocop:disable Metrics/MethodLength
      # TODO: Use a presenter here
      def show
        named_filter = params.fetch(:named_filter, "all").to_sym
        form = form_for(named_filter)
        query = LetterQuery.new(q: form.attributes)
        letters = find_and_authorize_letters(query)

        q = query.search

        locals = {
          letters: letters,
          q: q,
          form: form_for(named_filter)
        }

        # Could pass back a batchprint summary
        # {
        #   count: 123,
        #   excluded_enc: 3
        # }
        respond_to do |format|
          format.html { render(locals: locals) }
          format.js   { render(locals: locals, layout: false) }
        end
      end
      # rubocop:enable Metrics/MethodLength

      private

      def form_for(named_filter)
        Lists::Form.new(named_filter: named_filter, params: filter_parameters)
      end

      def find_and_authorize_letters(query)
        collection = call_query(query).page(page).per(per_page)
        present_letters(collection).tap { |letters| authorize letters }
      end

      def present_letters(letters)
        CollectionPresenter.new(letters, LetterPresenterFactory)
      end

      def call_query(query)
        query
          .call
          .with_patient
          .with_main_recipient
          .with_letterhead
          .with_author
          .with_created_by
      end

      # These are used also when creating a batch.
      # rubocop:disable Metrics/MethodLength
      def filter_parameters
        return {} unless params.key?(:q)

        params
          .require(:q)
          .permit(
            :enclosures_present,
            :notes_present,
            :state_eq,
            :author_id_eq,
            :created_by_id_eq,
            :letterhead_id_eq,
            :page_count_in_array,
            :clinic_visit_clinic_id_eq,
            :s
          )
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
