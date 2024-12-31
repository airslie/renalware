module Renalware
  module UKRDC
    class PathologyObservationRequestPresenter < SimpleDelegator
      # Note that we can't just use requestor_order_number as some OBR
      # segments arrive with a blank one. We need put something in the XML
      # that is unique per observation_request, but will still _be_ something
      # when requestor_order is blank
      def placer_id
        [
          requestor_order_number,
          requested_at.strftime("%Y%m%d%H%M%S%L"),
          description_id
        ].compact_blank.join("-")
      end
    end
  end
end
