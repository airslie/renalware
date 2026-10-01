module Renalware
  # When a session times out we remember where the timed-out user was, tied to that user,
  # rather than letting Devise store a location any user signing in next would be sent to.
  # Devise redirects a timed-out page request back to that page, and that unauthenticated request
  # on to the sign-in page. A timed-out background request or form submission is followed by a
  # page load (a reload, or a redirect to the form) which tells us where the user was.
  class Devise::FailureApp < ::Devise::FailureApp
    SIGNED_OUT_USER_ENV_KEY = "renalware.signed_out_user".freeze

    def respond
      remember_where_the_timed_out_user_was if timed_out_user
      super
    end

    protected

    def store_location!
      if resume_location.pending?
        resume_location.resolve(resumable_path) if page_request?
      elsif !resume_location.stored?
        super
      end
    end

    private

    def timed_out_user
      request.get_header(SIGNED_OUT_USER_ENV_KEY) if warden_message == :timeout
    end

    def remember_where_the_timed_out_user_was
      user = timed_out_user[:user]
      if page_request?
        resume_location.store(user:, path: resumable_path, expired_at: session_expired_at)
      else
        resume_location.store_pending(user:, expired_at: session_expired_at)
      end
    end

    def page_request?
      request.get? && !http_auth? && request.headers["Turbo-Frame"].blank?
    end

    # The attempted path includes any engine mount point, which the app's router needs in order
    # to recognise it, but not the app's own relative url root.
    def resumable_path
      path = Users::ResumablePath.new(attempted_path.delete_prefix(relative_url_root)).to_s
      "#{relative_url_root}#{path}" if path
    end

    def relative_url_root
      Rails.application.config.relative_url_root.to_s.chomp("/")
    end

    def session_expired_at
      last_request_at = timed_out_user[:last_request_at]
      return Time.current unless last_request_at.is_a?(Integer)

      Time.zone.at(last_request_at) + ::Devise.timeout_in
    end

    def resume_location
      @resume_location ||= Users::ResumeLocation.new(session)
    end
  end
end
