module Renalware
  module HD
    class OngoingSessionsController < BaseController
      include Pagy::Backend

      def show
        query = Sessions::OngoingQuery.new(q: params[:q])
        sessions = query.call
          .includes(
            :hospital_unit, :signed_on_by, :signed_off_by,
            patient: { current_modality: [:description] }
          )
        pagy, sessions = pagy(sessions)
        authorize sessions
        render locals: { query: query.search, sessions: sessions, pagy: pagy }
      end
    end
  end
end
