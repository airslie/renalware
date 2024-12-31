module Renalware
  module Transplants
    class DonorStagePosition < ApplicationRecord
      validates :name, presence: true, uniqueness: true
      validates :position, presence: true

      def to_s = name
    end
  end
end
