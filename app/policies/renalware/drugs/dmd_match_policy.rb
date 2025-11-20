module Renalware
  module Drugs
    class DMDMatchPolicy < BasePolicy
      def index?  = user_is_devops? && enabled?
      def new?    = user_is_devops? && enabled?
      def create? = user_is_devops? && enabled?

      private

      def enabled? = Renalware.config.enable_dmd_match
    end
  end
end
