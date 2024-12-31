module Renalware
  module Patients
    class PrimaryCarePhysicianPolicy < BasePolicy
      def search? = index?
    end
  end
end
