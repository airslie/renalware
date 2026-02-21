# frozen_string_literal: true

class Forms::Alcura::Homecare::Medications < Forms::Alcura::Homecare::Base
  def build # rubocop:disable Metrics/MethodLength
    move_down 5

    rows = []
    rows << heading_row
    args.medications.each do |medication|
      rows << row_for(medication)
    end

    table(
      rows,
      **table_styles,
      column_widths: {
        0 => 190,
        1 => 85,
        2 => 85,
        3 => 90,
        4 => 60,
        5 => 55
      }
    )
  end

  private

  def heading_row
    [
      green_heading_cell("MEDICATION"),
      green_heading_cell("Strength"),
      green_heading_cell("Form"),
      green_heading_cell("Directions"),
      green_heading_cell("Route"),
      green_heading_cell("Total Quantity")
    ]
  end

  def row_for(medication)
    [
      medication.drug,
      medication.dose,
      "",
      medication.frequency,
      medication.route,
      ""
    ]
  end
end
