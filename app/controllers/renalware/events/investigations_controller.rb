# This controller is mostly empty - we are using it for mainly routing and to let us
# override the events 'new' and 'edit' templates. See the base class for most functionality.
module Renalware
  module Events
    class InvestigationsController < EventsController
      # Override this because as we probably originated from the tx investigations page we want to
      # go back there when done editing or creating. This does not apply if we were created
      # from the generic Events list and controller.
      def return_url
        session.delete(:return_to)
        patient_transplants_recipient_dashboard_path(patient)
      end
    end
  end
end
