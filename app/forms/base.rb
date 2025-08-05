# frozen_string_literal: true

require "prawn/table"

class Forms::Base
  include Prawn::View

  EMPTY_CHECKBOX = "o     " #  in ZapfDingbats
  CHECKBOX = "n    "        #  in ZapfDingbats
  TABLE_WIDTH = 555

  pattr_initialize :document, :args

  def table_styles(**options)
    {
      cell_style: {
        padding: [1, 5, 1, 1],
        border_width: 0.5,
        border_color: "AAAAAA",
        **options
      }
    }
  end

  def heading(text, **options)
    {
      content: text,
      font_style: :bold,
      **options
    }
  end

  # lower case o is an empty checkbox in ZapfDingbats
  def cell_with_leading_checkbox(text, checked: false, **options)
    if checked
      { content: "<font name='ZapfDingbats'>#{CHECKBOX}</font>#{text}",
        inline_format: true,
        **options }
    else
      { content: "<font name='ZapfDingbats'>#{EMPTY_CHECKBOX}</font>#{text}",
        inline_format: true,
        **options }
    end
  end

  def cell_with_trailing_checkbox(text, checked: false, **options)
    if checked
      { content: "#{text} <font name='ZapfDingbats'>#{CHECKBOX}</font>",
        inline_format: true,
        **options }
    else
      { content: "#{text} <font name='ZapfDingbats'>#{EMPTY_CHECKBOX}</font>",
        inline_format: true,
        **options }
    end
  end

  def underlined_table_style
    { cell_style: {
      padding: [2, 5, 2, 0],
      border_width: 0.5,
      border_color: "AAAAAA",
      borders: [:bottom]
    } }
  end

  def borderless_table_style
    { cell_style: {
      border_width: 0.5
    } }
  end
end
