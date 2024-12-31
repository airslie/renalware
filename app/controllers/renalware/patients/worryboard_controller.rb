module Renalware
  module Patients
    class WorryboardController < BaseController
      include Renalware::Concerns::PatientVisibility
      include Renalware::Concerns::Pageable
      include Pagy::Backend

      def show
        authorize Worry, :index?
        query = WorryQuery.new(
          query_params: query_params,
          patient_scope: patient_scope
        )
        pagy, worries = pagy(query.call)
        render locals: {
          query: query.search,
          pagy: pagy,
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
