# frozen_string_literal: true

module Renalware
  module Renal
    class RegistryPreflightCheckPolicy < BasePolicy
      def deaths?
        index?
      end

      def patients?
        index?
      end

      def missing_esrf?
        index?
      end
    end
  end
end
