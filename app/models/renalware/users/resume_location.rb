module Renalware
  module Users
    # Remembers, in the session, where a user was when their session expired so that the same
    # user can be returned there if they sign in again soon enough. A blank path records that
    # there is nowhere to return them to. A pending location is one whose page is not yet known,
    # eg the session expired during a background request, and is resolved by the next page load.
    class ResumeLocation
      SESSION_KEY = "renalware.resume_location".freeze

      def initialize(session)
        @session = session
      end

      def store(user:, path:, expired_at:)
        session[SESSION_KEY] = timed_out(user, expired_at).merge("path" => path.presence)
      end

      def store_pending(user:, expired_at:)
        session[SESSION_KEY] = timed_out(user, expired_at)
      end

      def resolve(path)
        session[SESSION_KEY] = location.merge("path" => path.presence)
      end

      def stored?
        location.present?
      end

      def pending?
        stored? && !location.key?("path")
      end

      def consume_for(user)
        consumed = session.delete(SESSION_KEY)
        return if consumed.blank?
        return unless consumed["user_id"] == user.id
        return if Time.zone.at(consumed["expired_at"]) < memory_period.ago

        consumed["path"]
      end

      private

      attr_reader :session

      def location
        session[SESSION_KEY] || {}
      end

      def timed_out(user, expired_at)
        { "user_id" => user.id, "expired_at" => expired_at.to_i }
      end

      def memory_period
        Renalware.config.duration_of_last_url_memory_after_session_expiry
      end
    end
  end
end
