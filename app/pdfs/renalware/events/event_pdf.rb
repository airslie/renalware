module Renalware
  module Events
    # We have used wicked_pdf (which shells out to wkhtmltopdf) up to know, but using prawn here
    # as Event PDFs are somewhat simpler, and there is no extant html equivalent we can render.
    # Its also a useful test to see if this is a better approach all round. It is certainly much
    # quicker and less resource intensive to create the PDFs.
    class EventPdf
      include Prawn::View
      attr_reader :event

      delegate :patient, :event_type, to: :event

      def self.call(...)
        new(...).render
      end

      def initialize(event)
        @event = event
        build
      end

      def build
        render_hospital_centre_info
        render_patient_identifiers
        render_common_event_fields
        render_specific_event_fields(event.document)
        render_notes
        self
      end

      def render_header
        font_size 12
        text title
        move_down 10
        text event.patient.to_s, style: :bold
        move_down 10
      end

      def render_patient_identifiers
        move_cursor_to 675
        font_size 10
        bounding_box([0, cursor], width: 340) do
          render_header
          font_size 10
          text "DOB: #{I18n.l(patient.born_on)}"
          text "NHS: #{patient.nhs_number}"
          patient.hospital_identifiers.all.each do |key, value|
            text "#{key}: #{value}"
          end
          move_down 10
        end
      end

      def render_common_event_fields
        text "Date: #{I18n.l(event.date_time)}"
        move_down 10
        if event.respond_to?(:description)
          text "<u>Description</u>", inline_format: true
          move_down 5
          text event.description
          move_down 10
        end
      end

      def render_specific_event_fields(document)
        document.attributes.each do |name, value|
          # could handle recursive documents here but none exists ATM even in HEROIC
          text "#{document.class.human_attribute_name(name)}:    #{value}"
        end
        move_down 10
      end

      def render_notes
        text "<u>Notes</u>", inline_format: true
        move_down 5
        output_html_as_text_but_preserving_paragraph_breaks(text: event.notes)
      end

      def render_hospital_centre_info
        bounding_box([340, cursor], width: 200) do
          image_path = "app/assets/images/renalware/nhs_a4_letter_logo_black.png"
          image Renalware::Engine.root.join(image_path), height: 30, position: :right
          move_down 10
          text event.hospital_centre_trust_name, align: :right
          text event.hospital_centre_trust_caption, align: :right
          font_size 8
          output_html_as_text_but_preserving_paragraph_breaks(
            text: interpret_new_lines_in(event.hospital_centre_info),
            strip_tags: false,
            align: :right,
            inline_format: true
          )
          font_size 10
        end
      end

      # Ensure any new line characters in a string are interpreted as actual new lines.
      # This lets use /n in seed data and in the database.
      def interpret_new_lines_in(text)
        text&.gsub('\n', "\n")
      end

      # Create new line if there is a <br>.
      # If there is an empty line (caused by <br><br>) move down to indicate a new paragraph.
      def output_html_as_text_but_preserving_paragraph_breaks(text:, strip_tags: true, **args)
        return if text.blank?

        text.split("<br>").each do |paragraph|
          if strip_tags
            text(ActionView::Base.full_sanitizer.sanitize(paragraph), **args)
          else
            text(paragraph, **args)
          end
          move_down(10) if ActionView::Base.full_sanitizer.sanitize(paragraph).blank?
        end
      end

      def title
        event_type.title || event_type.name
      end
    end
  end
end
