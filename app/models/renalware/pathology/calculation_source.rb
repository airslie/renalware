module Renalware
  module Pathology
    # When we store a pathology observation that has been derived/calculated
    # as opposed to coming straight in from the lab (an example being URR which
    # at some sites we calculate from pre and post UREA) we can store the ids of the
    # observations used in the calculation here, to aid debugging and reuse.
    # So for example where a URR is our calculated_observation, we store the ids
    # of the pre UREA and the post UREA observations
    class CalculationSource < ApplicationRecord
      belongs_to :calculated_observation, class_name: "Observation"
      belongs_to :source_observation, class_name: "Observation"
      validates :calculated_observation, presence: true
      validates :source_observation, presence: true
    end
  end
end
