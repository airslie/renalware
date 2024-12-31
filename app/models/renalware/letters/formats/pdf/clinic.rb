module Renalware
  module Letters
    module Formats
      module Pdf
        class Clinic
          include Prawn::View
          pattr_initialize :document, :letter
          PRIVATE_AND_CONFIDENTIAL = "PRIVATE AND CONFIDENTIAL".freeze
          delegate :letterhead, to: :letter

          def build
            text letterhead.unit_info.presence || " "
            move_down 10
            text I18n.l(letter.date)
            text(letter.description, style: :bold) if letter.description.present?
            text(letter.simple_event_description) if letter.simple_event_description.present?
            move_down 10
            text PRIVATE_AND_CONFIDENTIAL
            move_down 10
          end
        end
      end
    end
  end
end
