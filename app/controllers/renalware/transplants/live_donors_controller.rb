module Renalware
  module Transplants
    class LiveDonorsController < BaseController
      include Renalware::Concerns::PatientVisibility
      include Pagy::Backend

      def index
        query = LiveDonorsQuery.new(
          params: params[:q],
          relation: policy_scope(Transplants::Patient.includes(:hospital_centre))
        )
        pagy, live_donors = pagy(query.call)

        authorize live_donors
        render locals: {
          live_donors: live_donors,
          q: query.search,
          pagy: pagy
        }
      end
    end
  end
end
