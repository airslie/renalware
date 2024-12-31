module Renalware
  module Letters
    module Formats
      module Pdf
        class Addressee
          include Prawn::View
          pattr_initialize :document, :letter
          delegate :patient, to: :letter

          def build
            # Move to the envelope window position
            move_cursor_to 655
            letter.main_recipient.address.to_a.each { |line| text line }
            move_down 30
            text letter.salutation
            move_down 10
            text "<u>#{letter.patient_summary_string}</u>", style: :bold, inline_format: true
            text "<u>#{patient.address.to_a.join(', ')}</u>", style: :bold, inline_format: true
          end
        end
      end
    end
  end
end
