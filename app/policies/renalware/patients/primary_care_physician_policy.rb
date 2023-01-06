# frozen_string_literal: true

module Renalware
  module Patients
    class PrimaryCarePhysicianPolicy < BasePolicy
      def search?
        index?
      end
    end
  end
end
