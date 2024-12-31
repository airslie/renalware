module Renalware
  module PD
    class RegimePolicy < BasePolicy
      def edit?
        super & record.current?
      end
    end
  end
end
