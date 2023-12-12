# frozen_string_literal: true

module Renalware
  module HD
    class SlotRequestPolicy < BasePolicy
      def historical? = index?
    end
  end
end
