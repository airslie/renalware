module Renalware
  class Devise::SessionsController < ::Devise::SessionsController
    include Concerns::DeviseControllerMethods
    include Concerns::ResumeAfterSignIn

    prepend_before_action :redirect_if_login_form_is_stale, only: :create

    def create
      user = Renalware::User.find_by(username: user_params[:username])

      user&.touch(:last_failed_sign_in_at) unless user_valid?(user)

      super do
        track_signin
      end
    end

    private

    def redirect_if_login_form_is_stale
      return if verified_request?

      reset_session
      redirect_to new_user_session_path, alert: t("devise.failure.stale_login_form")
    end

    def user_valid?(user)
      user&.valid_password?(user_params[:password])
    end

    def user_params
      @user_params ||= params.require("user").permit(:username, :password)
    end

    def track_signin
      ahoy.track "signin"
    end
  end
end
