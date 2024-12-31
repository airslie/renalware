module Renalware
  module Letters
    module Formats
      module Pdf
        class Letterhead
          include Prawn::View
          pattr_initialize :document

          def build # rubocop:disable Metrics/MethodLength
            float do
              bounding_box([230, 775], width: 300, height: 200) do
                image_path = "app/assets/images/renalware/nhs_a4_letter_logo_blue.png"
                image Renalware::Engine.root.join(image_path), position: :right, width: 45
                move_down 4
                font_size(11) do
                  text "King’s College Hospital", align: :right, style: :bold
                end

                pad_bottom(6) do
                  font_size(8) do
                    text "NHS Foundation Trust", align: :right, style: :bold, color: "005EB8"
                  end
                end

                font_size(6) do
                  text "Renal Administration", align: :right
                  text "King’s College Hospital", align: :right
                  text "Bessemer Road", align: :right
                  text "London SE5 9RS", align: :right
                  text "<b>Appointments:</b> 020 3299 6244", align: :right, inline_format: true
                  text "<b>Fax:</b> 020 3299 6472", align: :right, inline_format: true
                  text "<b>Switchboard:</b> 020 3299 9000", align: :right, inline_format: true
                  text "<b>GP Email Advice:</b> kch-tr.renal@nhs.net",
                       align: :right,
                       inline_format: true
                end
              end
            end
          end
        end
      end
    end
  end
end
