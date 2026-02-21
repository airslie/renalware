# frozen_string_literal: true

class Forms::Alcura::Homecare::Footer < Forms::Alcura::Homecare::Base
  def build # rubocop:disable Metrics/MethodLength
    move_cursor_to 50
    font_size(8) do
      text "Signed copy to be sent to: Alcura Ltd, Alcura House, Caswell Road," \
           "Brackmills Ind. Estate, Northampton, NN4 7PU", align: :center
      text "Tel: 01604 433 500   Fax: 01604 433 598", align: :center
      text "Original signed copy to be posted to Alcura as soon as possible", align: :center
      text "QPulse/Alcura/Commercial/Forms/FM250 v 1.1", align: :center

      font_size 6
      text_box(
        "RW v#{Renalware::VERSION}",
        at: [363, 10],
        width: 200,
        align: :right
      )
    end
  end
end
