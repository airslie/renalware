module Renalware
  module Renal
    class RegistryPreflightCheckPolicy < BasePolicy
      def deaths?       = index?
      def patients?     = index?
      def missing_esrf? = index?
    end
  end
end
