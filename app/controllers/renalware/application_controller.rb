module Renalware
  # Note that we inherit from ::ApplicationController which is defined in the host application.
  # This allows application to
  # - define the default layout
  # - intercept requests with before_action etc.
  class ApplicationController < ::ApplicationController
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :reset_session
  end
end
