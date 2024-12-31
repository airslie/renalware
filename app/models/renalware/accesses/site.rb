module Renalware
  module Accesses
    class Site < ApplicationRecord
      validates :code, presence: true
      validates :name, presence: true

      scope :ordered, -> { order(:name) }

      def to_s = name
    end
  end
end
