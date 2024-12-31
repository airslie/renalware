require "active_support/concern"

# The host Rails application's ApplicationController could choose to mix-in this concern in order to
# prevent the browser from being able navigate Back to logged-in pages once the user has logged out.
module Renalware
  module Concerns::CacheBusting
    extend ActiveSupport::Concern

    included do
      class_eval do
        before_action :bust_cache
      end
    end

    def bust_cache
      response.headers["Cache-Control"] = "no-cache, no-store"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    end
  end
end
