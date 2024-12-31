module Renalware
  module Letters
    class Event::ClinicVisit < Event
      include ::ActionView::Helpers
      include ::ActionView::Context

      def initialize(event, clinical:)
        super(event, clinical: true)
      end

      def description
        tag.span do
          concat(tag.span { "Clinic: #{clinic&.description}" })
          concat(
            tag.span(style: "white-space: nowrap;") do
              " on #{::I18n.l(date.to_date, format: :long)}"
            end
          )
        end
      end

      def part_classes
        super.push(Part::ClinicalObservations)
      end

      def to_s
        "Clinic Visit"
      end

      def clinical?
        true
      end

      def to_link
        lambda { |patient, event = self|
          link_to(
            event.to_s,
            ::Renalware::Engine.routes.url_helpers.edit_patient_clinic_visit_path(patient, event)
          )
        }
      end
    end
  end
end
