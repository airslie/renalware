module Renalware
  module Transplants
    class RejectionTreatment < ApplicationRecord
      validates :name, presence: true
      scope :ordered, -> { order(:position) }

      def to_s = name
    end
  end
end
