# frozen_string_literal: true

class Forms::Generic::Homecare::DeliveryFrequencies < Forms::Base
  def build
    font_size 10
    move_down 10
    row = [heading("Frequency of deliveries:")]
    args.delivery_frequencies.each do |freq|
      checked = freq == args.selected_delivery_frequency
      row.concat << cell_with_leading_checkbox(freq, checked:)
    end

    table(
      [row],
      **table_styles(border_width: 0, padding: [1, 30, 1, 0]),
      column_widths: { 0 => 150 }
    )
  end
end
