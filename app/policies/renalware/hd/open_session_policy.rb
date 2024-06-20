# frozen_string_literal: true

module Renalware
  module HD
    class OpenSessionPolicy < BasePolicy
      def destroy?  = edit?
      def edit?     = record.persisted?
    end
  end
end
