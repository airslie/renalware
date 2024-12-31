module Renalware
  module Patients
    class PracticePolicy < BasePolicy
      def search? = index?
    end
  end
end
