# frozen_string_literal: true

module Renalware
  module Events
    class ListsController < BaseController
      include Pagy::Backend
      include Renalware::Concerns::Pageable
      use_layout :simple

      def show
        query = EventListQuery.new(params: form.attributes)
        pagy, events = pagy(query.call, item_extras: true)
        authorize events
        render locals: { events: events, q: query.search, form: form, pagy: pagy }
      end

      private

      def form
        @form ||= form_for(named_filter)
      end

      # Get requests to #show may have a filter param {} if filters where selected (eg an event
      # type) and if any sorting was done there will also be e.g. params[:q][:s] = "something asc"
      # The EventListQuery just accepts our form object, from which it attributes to ransack, so
      # here we need to make sure the search
      def form_for(named_filter)
        Lists::Form.new(
          named_filter: named_filter,
          params: add_ransack_search_param_to_filter_parameters
        )
      end

      def named_filter
        @named_filter ||= params.fetch(:named_filter, "all").to_sym
      end

      def add_ransack_search_param_to_filter_parameters
        filter_parameters.merge(s: params.dig(:q, :s))
      end

      def filter_parameters
        return {} unless params.key?(:filters)

        params
          .require(:filters)
          .permit(
            :event_type_id_eq,
            :created_by_id_eq,
            :created_at_gteq,
            :created_at_lteq,
            :from,
            :to
          )
      end
    end
  end
end
