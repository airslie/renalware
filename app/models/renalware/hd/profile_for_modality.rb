module Renalware
  module HD
    # Backed by a (scenic) view this model is used to resolve the HD Profile in use or created
    # just after a patient was assigned an HD modality,
    # Note that this view could have been written as a SQL function or a ruby query object.
    # I implemented it as a view because I would like semi technical people to be able to inspect
    # the view to ascertain which HD modalities have no profile etc. Its just easier to review the
    # data if it is a view.
    #
    # Example usage
    #  modality_profile = HD::ProfileForModality.where(modality_id: 1)
    #  modality_profile.hd_profile_id # => 123
    class ProfileForModality < ApplicationRecord
    end
  end
end
