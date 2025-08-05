module Renalware
  module Letters::Transports::Mesh
    class UnreconciledMessagesController < BaseController
      include Pagy::Backend

      layout -> { turbo_frame_request? ? "turbo_rails/frame" : "renalware/layouts/admin" }

      def index
        authorize Operation, :index?
        search = Operation
          .where(reconciliation_error: true)
          .order(created_at: :desc)
          .ransack(params.fetch(:q, {}))
        pagy, operations = pagy(search.result)
        render locals: {
          operations: operations,
          pagy: pagy,
          search: search
        }
      end
    end
  end
end
