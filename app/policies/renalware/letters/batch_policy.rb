module Renalware
  module Letters
    class BatchPolicy < BasePolicy
      def status? = show?
    end
  end
end
