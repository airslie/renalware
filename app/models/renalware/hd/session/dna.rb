module Renalware
  module HD
    class Session::DNA < Session
      include Document::Base

      class Document < Document::Embedded
        attribute :patient_on_holiday, ::Document::Enum, enums: %i(yes no)
        validates :patient_on_holiday, presence: true
      end

      has_document class_name: "Renalware::HD::Session::DNA::Document"

      def self.policy_class = DNASessionPolicy

      def immutable?
        return true unless persisted?

        temporary_editing_window_has_elapsed?
      end

      private

      def temporary_editing_window_has_elapsed?
        delay = Renalware.config.delay_after_which_a_finished_session_becomes_immutable
        (Time.zone.now - delay) > created_at
      end
    end
  end
end
