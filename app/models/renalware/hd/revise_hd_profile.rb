module Renalware
  module HD
    class ReviseHDProfile
      attr_reader :profile, :new_profile

      def initialize(profile)
        raise(ArgumentError, "Cannot revise a new Profile") unless profile.persisted?

        @profile = profile
      end

      def call(params)
        profile.assign_attributes(params)
        return true unless profile.changed?
        return false unless profile.valid?

        profile.restore_attributes
        @new_profile = profile.supersede!(params)
      end
    end
  end
end
