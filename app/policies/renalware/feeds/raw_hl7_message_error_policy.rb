module Renalware
  module Feeds
    class RawHL7MessageErrorPolicy < BasePolicy
      def index? = user_is_super_admin?
      def show? = user_is_super_admin?
    end
  end
end
