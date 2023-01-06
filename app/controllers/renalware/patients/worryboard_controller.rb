# frozen_string_literal: true

module Renalware
  module Patients
    class WorryboardController < BaseController
      include Renalware::Concerns::PatientVisibility
      include Renalware::Concerns::Pageable

      def show
        authorize Worry, :index?
        query = WorryQuery.new(
          query_params: query_params,
          patient_scope: patient_scope
        )
        worries = query.call.page(page).per(per_page)
        render locals: {
          query: query.search,
          worries: worries,
          modalities: Modalities::Description.order(:name),
          categories: WorryCategory.order(:name)
        }
      end

      private

      def query_params
        params.fetch(:q, {})
      end
    end
  end
end
