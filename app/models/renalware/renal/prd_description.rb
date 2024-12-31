module Renalware
  module Renal
    class PRDDescription < ApplicationRecord
      scope :ordered, -> { order(:id) }

      def to_s
        "#{term} [#{code}]"
      end
    end
  end
end
