module Renalware
  module Events
    class EventPolicy < BasePolicy
      delegate(
        :author_change_window_hours,
        :admin_change_window_hours,
        :superadmin_can_always_change?,
        :save_pdf_to_electronic_public_register?,
        to: :event_type
      )

      # Do not allow events that are rendered to PDF to be edited or deleted as it may not be
      # possible to recall the document once sent to e.g. EPR.
      def edit?
        return false if save_pdf_to_electronic_public_register?
        return true if user_is_super_admin? && superadmin_can_always_change?
        return true if user_is_any_admin? && admin_change_window_open?
        return true if author? && author_change_window_open?

        false
      end
      alias update? edit?

      def event_type
        record.event_type || fallback_event_type
      end

      def destroy?
        # Allow a superadmin to delete events even if they have been sent to EPR as a PDF.
        return true if user_is_super_admin? && save_pdf_to_electronic_public_register?

        # Otherwise default behaviour
        edit?
      end

      private

      def author_change_window_open?
        return false if author_change_window_hours.zero? # never
        return true if author_change_window_hours == -1 # forever
        return true if record.created_at.nil?

        expires_at = (Time.zone.now - author_change_window_hours.hours).to_datetime

        record.created_at > expires_at
      end

      def admin_change_window_open?
        return false if admin_change_window_hours.zero?
        return true if admin_change_window_hours == -1 # forever
        return true if record.created_at.nil?

        expires_at = (Time.zone.now - admin_change_window_hours.hours).to_datetime

        record.created_at > expires_at
      end

      def author?
        record.created_by == user
      end

      def fallback_event_type
        Events::Type.new
      end
    end
  end
end
