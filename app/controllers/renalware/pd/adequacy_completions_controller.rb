module Renalware
  module PD
    class AdequacyCompletionsController < BaseController
      include Pagy::Backend

      def index
        query = AdequacyResult.joins(:patient).order(performed_on: :desc).ransack(params[:q])
        pagy, results = pagy(query.result)
        authorize results
        render locals: { pagy: pagy, results: results, query: query }
      end
    end
  end
end
