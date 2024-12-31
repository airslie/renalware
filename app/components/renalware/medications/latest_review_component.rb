module Renalware
  module Medications
    # Displays details about the last medication review the patient had.
    # Can be used in the UI and on letters.
    # The text to display is loaded from the sidecar i18n yml using interpolation
    # in order to give more freedom for a hospital to override how the text is
    # displayed.
    # If compact: true is passed then we load a shorter title.
    class LatestReviewComponent < ApplicationComponent
      pattr_initialize [:patient!, compact: false]

      def review
        @review ||= patient.medication_reviews.latest
      end

      def render?
        review.present?
      end

      def title
        t(i18n_title_key, date: reviewed_on, user: reviewer)
      end

      def i18n_title_key
        compact ? ".compact_title" : ".title"
      end

      def reviewer
        review.created_by.professional_signature
      end

      def reviewed_on
        l(review.date_time.to_date)
      end
    end
  end
end
