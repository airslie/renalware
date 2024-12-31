module Renalware
  module Letters::Transports::Mesh
    class TransmissionsController < BaseController
      include Pagy::Backend
      layout -> { turbo_frame_request? ? "turbo_rails/frame" : "renalware/layouts/admin" }

      def index
        authorize Transmission, :index?
        search = Transmission
          .order(created_at: :desc)
          .includes(:operations)
          .includes(letter: :patient)
          .ransack(params.fetch(:q, {}))
        pagy, transmissions = pagy(search.result)
        authorize transmissions
        render locals: { transmissions: transmissions, pagy: pagy, search: search }
      end

      def show
        transmission = Transmission.find(params[:id])
        authorize transmission
        render locals: { transmission: transmission }
      end
    end
  end
end
