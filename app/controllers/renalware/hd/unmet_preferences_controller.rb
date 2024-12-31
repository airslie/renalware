module Renalware
  module HD
    class UnmetPreferencesController < BaseController
      include PresenterHelper
      include Pagy::Backend

      def index
        query = PatientsWithUnmetPreferencesQuery.new(query_params)
        pagy, patients = pagy(query.call)
        authorize(patients)
        render locals: {
          query: query.search,
          patients: present(patients, UnmetPreferencesPresenter),
          pagy: pagy
        }
      end

      private

      def query_params
        params.fetch(:q, {})
      end
    end
  end
end
