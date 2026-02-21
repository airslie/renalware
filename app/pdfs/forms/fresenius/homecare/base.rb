# frozen_string_literal: true

class Forms::Fresenius::Homecare::Base < Forms::Base
  pattr_initialize :document, :args

  LIGHT_BLUE = "c6d9f1"
  DARK_BLUE = "0033cc"
  WHITE = "FFFFFF"
  TABLE_WIDTH = 565

  def light_blue_cell(text, **options)
    {
      content: text,
      background_color: LIGHT_BLUE,
      align: :right,
      **options
    }
  end

  def light_blue_heading_cell(text, background_color: LIGHT_BLUE, **options)
    {
      content: text,
      background_color:,
      align: :left,
      font_style: :bold,
      **options
    }
  end

  def table_styles
    {
      cell_style: {
        padding: [2, 5, 2, 2],
        border_width: 0.5
      }
    }
  end
end
