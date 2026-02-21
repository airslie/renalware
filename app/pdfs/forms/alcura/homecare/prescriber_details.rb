# frozen_string_literal: true

class Forms::Alcura::Homecare::PrescriberDetails < Forms::Alcura::Homecare::Base
  def build # rubocop:disable Metrics/MethodLength
    move_down 5
    table(
      [
        [
          green_heading_cell("PRESCRIBER'S DETAILS", colspan: 4)
        ],
        [
          heading("Prescriber's Name"),
          "",
          heading("Prescriber's\nSignature"),
          ""
        ],
        [
          heading("Registration Number  (GMC, PIP, NMC)"),
          "",
          heading("Date"),
          ""
        ]
      ],
      column_widths: {
        0 => TABLE_WIDTH / 4,
        1 => TABLE_WIDTH / 4,
        2 => TABLE_WIDTH / 4,
        3 => TABLE_WIDTH - ((TABLE_WIDTH / 4) * 3)
      },
      **table_styles
    )
  end
end
