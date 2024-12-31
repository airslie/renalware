module Renalware
  module System
    class OnlineReferenceLinkPolicy < BasePolicy
      def search? = index?
    end
  end
end
