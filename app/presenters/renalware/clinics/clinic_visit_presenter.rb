module Renalware
  module Clinics
    class ClinicVisitPresenter < DumbDelegator
      def sanitized_notes
        ::Rails::Html::WhiteListSanitizer.new.sanitize(notes, tags: %w(p br ol li ul span div))
      end

      def height_in_cm
        return if height.blank?

        height * 100
      end
    end
  end
end
