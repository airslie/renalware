module Renalware
  module HD
    class StationLocation < ApplicationRecord
      validates :name, presence: true, uniqueness: true
      validates :colour, presence: true
    end
  end
end
