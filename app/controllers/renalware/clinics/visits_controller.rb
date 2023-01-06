# frozen_string_literal: true

# Global visits not scoped to a patient
module Renalware
  module Clinics
    class VisitsController < BaseController
      # TODO: PatientVsibility?
      include Renalware::Concerns::Pageable

      def index
        visits_query = VisitQuery.new(query_params)
        visits = visits_query.call.page(page).per(per_page)
        authorize visits

        render locals: {
          visits: CollectionPresenter.new(visits, ClinicVisitPresenter),
          query: visits_query.search,
          clinics: Clinic.ordered,
          users: User.ordered
        }
      end

      private

      def query_params
        params.fetch(:q, {})
      end
    end
  end
end
