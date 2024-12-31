class ApplicationController < ActionController::Base
  include Renalware::Concerns::CacheBusting
  protect_from_forgery with: :reset_session
  helper Renalware::Engine.helpers
  layout -> { turbo_frame_request? ? "turbo_rails/frame" : "renalware" }

  private

  # rubocop:disable Style/ConditionalAssignment
  # There 2 ways a user can explicitly request the language/locale they want:
  # - they can explicitly choose their language in their profile (current_user.language)
  # - we could read their locale from the HTTP header sent by the browser and use this if supported
  # If these are missing or the requested language is unsupported, there are two ways we can
  # specify the default locale
  # - it the ENV variable DEFAULT_LANG is set (e.g. to "pt" for Portuguese) then we will default to
  #   this.  This mechanism is useful for testing new languages on Heroku because we can see the
  #   the login page for instance in a different language without fudging the HTTP_ACCEPT_LANGUAGE
  #   header
  # - the standard Rails I18n.default_locale setting
  def set_locale
    if user_signed_in?
      I18n.locale = current_user.language.presence || ENV.fetch("DEFAULT_LANG") {
        I18n.default_locale
      }
    else
      I18n.locale = ENV.fetch("DEFAULT_LANG") { I18n.default_locale }
    end
  end
  # rubocop:enable Style/ConditionalAssignment

  # See comments above. Not currently called.
  def locale_from_header
    request.env.fetch("HTTP_ACCEPT_LANGUAGE", "").scan(/[a-z]{2}/).first
  end
end
