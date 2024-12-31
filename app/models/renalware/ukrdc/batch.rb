module Renalware
  module UKRDC
    class Batch < ApplicationRecord
      def self.next
        create!
      end

      def number
        id.to_s.rjust(6, "0")
      end

      def to_s
        number
      end
    end
  end
end
