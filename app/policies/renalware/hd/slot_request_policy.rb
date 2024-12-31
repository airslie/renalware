module Renalware
  module HD
    class SlotRequestPolicy < BasePolicy
      def historical? = index?
    end
  end
end
