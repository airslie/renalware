module Renalware
  module Feeds
    class RawHL7MessageErrorsController < BaseController
      include Pagy::Backend

      def index
        authorize Feeds::RawHL7MessageError

        pagy, errors = pagy(
          Feeds::RawHL7MessageError.order(created_at: :desc)
        )

        render locals: { errors:, pagy: }
      end

      def show
        error = Feeds::RawHL7MessageError.find(params[:id])
        authorize error

        render locals: { error: }
      end
    end
  end
end
