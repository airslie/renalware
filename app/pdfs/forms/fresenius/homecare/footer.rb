# frozen_string_literal: true

class Forms::Fresenius::Homecare::Footer < Forms::Fresenius::Homecare::Base
  def build
    font_size 6
    text_box(
      "RW v#{Renalware::VERSION}",
      at: [350, 10],
      width: 200,
      align: :right
    )
  end
end
