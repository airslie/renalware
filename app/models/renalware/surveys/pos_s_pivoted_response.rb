# frozen_string_literal: true

module Renalware
  module Surveys
    class POSSPivotedResponse < ApplicationRecord
      scope :ordered, -> { order(answered_on: :desc) }
    end
  end
end
