# frozen_string_literal: true

class Forms::Alcura::Homecare::Base < Forms::Base
  pattr_initialize :document, :args

  GREEN = "99dccc"
  WHITE = "FFFFFF"
  TABLE_WIDTH = 565

  def green_heading_cell(text, background_color: GREEN, **options)
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
        padding: [2, 4, 2, 4],
        border_width: 0.5,
        size: 10
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

  # Creates a single row (array) where col 0 is the title and there are then n cell
  # where n == options.length, and each cell contains a checkbox+label, and only the last
  # cell has any vertical borders.
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def row_with_title_and_array_of_checkbox_options(
    title:,
    options:,
    title_col_width: 140,
    selected_option: nil
  )
    count = options.length
    count = 1 if count == 0
    col_width = (TABLE_WIDTH - title_col_width) / count

    column_widths = {}
    column_widths[0] = title_col_width

    row = [
      green_heading_cell(title)
    ]
    options.each_with_index do |option, index|
      checked = selected_option == option
      row << cell_with_leading_checkbox(option, checked:, borders: [:top, :bottom])
      last_col_width = if index + 1 == count
                         TABLE_WIDTH - title_col_width - (col_width * (count - 1))
                       else
                         col_width
                       end
      column_widths[index + 1] = last_col_width
    end

    table([row], **table_styles, column_widths:) do
      # Only the last cell has a right border as well as top and bottom
      row = row(0)
      last_cell = row.columns(count)
      last_cell.borders = %i(right top bottom)
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
