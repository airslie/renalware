module Renalware
  module Surveys
    class PosSPivotedResponse < ApplicationRecord
      scope :ordered, -> { order(answered_on: :desc) }
    end
  end
end
