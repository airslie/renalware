module Renalware
  module LowClearance
    class Referrer < ApplicationRecord
      validates :name, presence: true, uniqueness: true
      scope :ordered, -> { order(name: :asc) }

      def to_s = name
    end
  end
end
