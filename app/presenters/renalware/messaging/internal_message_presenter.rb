require_dependency "renalware/messaging"

module Renalware
  module Messaging
    class InternalMessagePresenter < SimpleDelegator
      def age_in_days
        (Time.zone.now.to_date - sent_at.to_date).to_i
      end

      def html_identifier
        "message-#{id}"
      end

      def html_preview_identifier
        "message-preview-#{id}"
      end
    end
  end
end
