# frozen_string_literal: true

class Forms::Generic::Homecare::Footer < Forms::Base
  def build
    font_size 6
    text_box "v#{Renalware::VERSION}", at: [350, 10], width: 200, align: :right
  end
end
