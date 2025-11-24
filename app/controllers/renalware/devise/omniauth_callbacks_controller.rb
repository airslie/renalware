module Renalware
  module Devise
    # rubocop:disable Rails/I18nLocaleTexts
    class OmniauthCallbacksController < ::Devise::OmniauthCallbacksController
      def entra_id
        auth = request.env["omniauth.auth"]
        @user = User.from_entra_id_omniauth(auth)

        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication
          set_flash_message(:notice, :success, kind: "Microsoft") if is_navigational_format?
        else
          session["devise.entra_id_data"] = auth.except("extra")
          redirect_to new_user_session_path, alert: "Could not sign in with Microsoft."
        end
      end

      def failure
        redirect_to root_path, alert: "Sign-in failed."
      end
    end
    # rubocop:enable Rails/I18nLocaleTexts
  end
end
