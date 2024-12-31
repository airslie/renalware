module Renalware
  module Letters
    class CompletedBatchesController < BaseController
      include Renalware::Concerns::Pageable

      # Renders a modal asking the user if they want to complete (ie mark as printed)
      # the batch.
      def new
        batch = find_and_authorize_batch
        render layout: false, locals: { batch: batch }
      end

      def create
        batch = find_and_authorize_batch
        Printing::CompleteBatch.new(user: current_user, batch: batch).call
        render layout: false, locals: { batch: batch }
      end

      private

      def find_and_authorize_batch
        Letters::Batch.find(params[:batch_id]).tap do |batch|
          authorize batch
        end
      end
    end
  end
end
