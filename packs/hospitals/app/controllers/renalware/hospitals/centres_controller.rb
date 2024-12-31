module Renalware
  module Hospitals
    class CentresController < BaseController
      include Pagy::Backend

      def index
        query = params.fetch(:q, {})
        query[:s] ||= "name"
        search = Centre.ordered.ransack(query)
        pagy, centres = pagy(search.result)
        authorize centres
        render locals: { centres: centres, search: search, pagy: pagy }
      end
    end
  end
end
