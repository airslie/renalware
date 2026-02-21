# frozen_string_literal: true

class Forms::Fresenius::Homecare::ReturnAddress < Forms::Fresenius::Homecare::Base
  def build # rubocop:disable Metrics/MethodLength
    font_size 8
    bounding_box([430, 810], width: 135, height: 100) do
      pad(5) do
        indent(5) do
          text(
            "Please return to\n\n" \
            "Fresenius Medical Care\n" \
            "Nunn Brook Road\n" \
            "Huthwaite, Sutton-in-Ashfield\n" \
            "Nottinghamshire\n" \
            "NG17 2HU\n" \
            "fmc.pharmacyteam@nhs.net\n" \
            "fmc.pharmacy-uk@fmc-ag.com\n" \
            "Pharmacy Tel: 01623 518919"
          )
        end
      end
      transparent(0.5) { stroke_bounds }
    end
    move_down 5
  end
end
