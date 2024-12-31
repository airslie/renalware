module Renalware
  module Transplants
    class RegistrationPolicy < BasePolicy
      def new?
        super && record.new_record?
      end
    end
  end
end
