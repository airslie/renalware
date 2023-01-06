# frozen_string_literal: true

module Renalware
  module Transplants
    class WaitListsController < BaseController
      include Renalware::Concerns::Pageable

      # Here we display a named filter eg Active and query for patients based on registration
      # status and also any search criteria entered in the search form which is backed by our
      # ransack #search object.
      def show
        form = Registrations::WaitListForm.new(form_params)
        query = query_for(form)
        registrations = query.call.page(page).per(per_page || 50)
        authorize registrations
        render locals: {
          path_params: path_params,
          registrations: CollectionPresenter.new(registrations, WaitListRegistrationPresenter),
          q: query.search,
          form: form
        }
      end

      private

      def query_for(form)
        Registrations::WaitListQuery.new(
          named_filter: params[:named_filter],
          ukt_recipient_number: form.ukt_recipient_number,
          q: params[:q]
        )
      end

      def path_params
        params.permit([:controller, :action, :named_filter])
      end

      def form_params
        params.fetch(:form, {}).permit(:ukt_recipient_number)
      end
    end
  end
end
