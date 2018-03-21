# frozen_string_literal: true

require_dependency "renalware/events"
require_dependency "renalware/virology"

# This controller is mostly empty - we are using it for mainly routing and to let us
# override the events 'new' and 'edit' templates. See the base class for most functionality.
module Renalware
  module Virology
    class VaccinationsController < Events::EventsController
    end
  end
end
