# frozen_string_literal: true

class Forms::Alcura::Homecare::Comments < Forms::Alcura::Homecare::Base
  def build
    table(
      [
        [green_heading_cell("COMMENTS")],
        ["\n\n\n"]
      ],
      **table_styles,
      column_widths: { 0 => TABLE_WIDTH }
    )
  end
end
