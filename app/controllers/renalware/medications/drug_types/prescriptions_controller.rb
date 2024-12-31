#
# E.g. medications/esa_prescriptions
# See routes.rb for how drug type name is set.
#
module Renalware
  module Medications
    module DrugTypes
      class PrescriptionsController < BaseController
        include Pagy::Backend

        def index
          authorize Prescription, :index?
          pagy, prescriptions = pagy(query.call)
          render :index, locals: {
            prescriptions: CollectionPresenter.new(prescriptions, PrescriptionPresenter),
            search: query.search,
            pagy: pagy
          }
        end

        private

        def query
          @query ||= PrescriptionsByDrugTypeQuery.new(
            drug_type_name: drug_type_name,
            search_params: params[:q]
          )
        end

        def drug_type_name
          params.fetch(:drug_type_name)
        end
      end
    end
  end
end
