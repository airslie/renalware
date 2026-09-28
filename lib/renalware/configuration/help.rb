module Renalware
  class Configuration
    module Help
      def self.included(base)
        # URL of an externally-hosted HTML or PDF Renalware user guide.
        base.config_accessor(:help_user_guide_link) do
          ENV.fetch("HELP_USER_GUIDE_LINK", "https://docs.renalware.com/user-guide")
        end

        base.config_accessor(:help_training_videos_link) do
          ENV.fetch("HELP_TRAINING_VIDEOS_LINK", "https://airslie.com/rw_onboarding/")
        end

        base.config_accessor(:help_tours_page_cache_expiry_seconds) do
          ENV.fetch("HELP_TOURS_PAGE_CACHE_EXPIRY_SECONDS", "3600").to_i
        end
      end
    end
  end
end
