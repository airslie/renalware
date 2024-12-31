#
# From https://gist.github.com/josevalim/fb706b1e933ef01e4fb6
#
require "devise"

module Renalware
  module API
    class TokenAuthenticatedAPIController < ApplicationController
      before_action :authenticate_user_from_token!
      before_action :authenticate_user! # fallback

      private

      def authenticate_user_from_token!
        username = params[:username].presence
        user = username && User.find_by(username: username)

        # Notice how we use Devise.secure_compare to compare the token
        # in the database with the token given in the params, mitigating
        # timing attacks.
        if user && ::Devise.secure_compare(user.authentication_token, params[:token])
          sign_in user, store: false
        end
      end
    end
  end
end
