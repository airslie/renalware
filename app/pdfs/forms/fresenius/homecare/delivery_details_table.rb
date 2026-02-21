# frozen_string_literal: true

class Forms::Fresenius::Homecare::DeliveryDetailsTable < Forms::Fresenius::Homecare::Base
  def build # rubocop:disable Metrics/MethodLength
    move_down 5
    table(
      [
        [
          light_blue_heading_cell("DELIVERY DETAILS", colspan: 3)
        ],
        [
          light_blue_cell("Delivery frequency"), args.selected_delivery_frequency, ""
        ],
        [
          light_blue_cell("Urgency of first delivery of this prescription:", rowspan: 3),
          cell_with_leading_checkbox("Next scheduled delivery", font_style: :bold),
          cell_with_leading_checkbox("Sharps Box required")
        ],
        [
          cell_with_leading_checkbox("Alternative / Urgent delivery", font_style: :bold),
          "Other comments"
        ],
        [
          "Please specify requirements",
          ""
        ]
      ],
      column_widths: { 0 => 165, 1 => 200, 2 => TABLE_WIDTH - (165 + 200) },
      **table_styles
    )
  end
end
