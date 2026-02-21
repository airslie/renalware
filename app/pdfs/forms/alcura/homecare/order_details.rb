# frozen_string_literal: true

class Forms::Alcura::Homecare::OrderDetails < Forms::Alcura::Homecare::Base
  def build # rubocop:disable Metrics/MethodLength
    move_down 5
    table(
      [
        [
          green_heading_cell("ORDER DETAILS", colspan: 2)
        ],
        [
          {
            content: "New Patient <font name='ZapfDingbats'>#{EMPTY_CHECKBOX}</font><br>" \
                     "Renewal <font name='ZapfDingbats'>#{EMPTY_CHECKBOX}</font><br>" \
                     "Drug/Dose change <font name='ZapfDingbats'>#{EMPTY_CHECKBOX}</font>",
            inline_format: true
          },
          {
            content: "NHS Funded <font name='ZapfDingbats'>#{EMPTY_CHECKBOX}</font><br>" \
                     "Self funded <font name='ZapfDingbats'>#{EMPTY_CHECKBOX}</font><br>" \
                     "Manufacturer funded <font name='ZapfDingbats'>#{EMPTY_CHECKBOX}</font>",
            inline_format: true
          }
        ],
        [
          heading("PO"),
          heading("Blueteq")
        ]
      ],
      column_widths: { 0 => TABLE_WIDTH / 2, 1 => TABLE_WIDTH / 2 },
      **table_styles
    )
  end
end
