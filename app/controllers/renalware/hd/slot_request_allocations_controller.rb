module Renalware
  module HD
    class SlotRequestAllocationsController < BaseController
      def create
        slot_request = SlotRequest.find(params[:id])
        authorize slot_request
        if slot_request.update_by(current_user, allocated_at: Time.zone.now)
          redirect_to renalware.hd_slot_requests_path
        end
        # TODO: handle where we cannot save
      end
    end
  end
end
