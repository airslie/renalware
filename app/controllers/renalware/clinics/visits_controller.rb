# Global visits not scoped to a patient
module Renalware
  module Clinics
    class VisitsController < BaseController
      include Pagy::Backend

      def index
        visits_query = VisitQuery.new(query_params)
        pagy, visits = pagy(visits_query.call)
        authorize visits

        render locals: {
          visits: CollectionPresenter.new(visits, ClinicVisitPresenter),
          query: visits_query.search,
          clinics: Clinic.ordered,
          users: User.ordered,
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
