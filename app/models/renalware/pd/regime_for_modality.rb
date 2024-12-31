module Renalware
  module PD
    # Backed by a (scenic) view this model is used to resolve the PD Regime in use or created
    # just after a patient was assigned an PD modality,
    # Note that this view could have been written as a SQL function or a ruby query object.
    # I implemented it as a view because I would like semi-technical people to be able to inspect
    # the view to ascertain which PD modalities have no regime. Its just easier to review the
    # data if it is a view.
    #
    # Example usage
    #  modality_regime = PD::RegimeForModality.where(modality_id: 1)
    #  modality_regime.pd_regime_id # => 123
    #
    class RegimeForModality < ApplicationRecord
    end
  end
end
