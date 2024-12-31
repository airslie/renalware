module Renalware
  module HD
    class DiurnalPeriodCode < ApplicationRecord
      validates :code, presence: true, uniqueness: true
      scope :for, ->(code) { where(code: code) }

      def to_s
        code
      end
    end
  end
end
