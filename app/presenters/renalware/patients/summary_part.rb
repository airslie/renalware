module Renalware
  module Patients
    class SummaryPart < Renalware::SummaryPart
      delegate :worry, to: :patient

      def to_partial_path
        "renalware/patients/summary_part"
      end

      def on_worryboard?
        worry.present?
      end

      def worryboard_notes
        worry&.notes
      end

      def bookmarked?
        bookmark.present?
      end

      def bookmark_notes
        bookmark&.notes
      end

      def bookmark
        return if current_user.blank?

        @bookmark ||= patients_user.bookmark_for_patient(patient)
      end

      def patients_user
        Patients.cast_user(current_user)
      end

      def bookmark_tags
        return [] if bookmark.blank?
        return [] if bookmark.tags.blank?

        bookmark
          .tags
          .split(",")
          .compact_blank
          .map(&:strip)
          .uniq
      end
    end
  end
end
