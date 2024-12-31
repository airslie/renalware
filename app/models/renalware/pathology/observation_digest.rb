module Renalware
  module Pathology
    # Backed by a view, returns pathology results grouped by the day the observation
    # was made. Please check if this is used in code - it may not be,
    # However the underlying view is a useful way of investigating a patient's results
    # so please do not remove the view.
    class ObservationDigest < ApplicationRecord
    end
  end
end
