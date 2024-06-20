# frozen_string_literal: true

module Renalware
  module System
    class OnlineReferenceLinkPolicy < BasePolicy
      def search? = index?
    end
  end
end
