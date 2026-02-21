# frozen_string_literal: true

class Forms::Fresenius::Homecare::PrescriberDetailsTable < Forms::Fresenius::Homecare::Base
  def build # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    move_down 5
    table(
      [
        [
          light_blue_heading_cell("PRESCRIBER DETAILS", colspan: 2),
          light_blue_heading_cell("PHARMACIST CHECK", colspan: 2)
        ],
        [
          light_blue_cell("Signature"), "\n\n\n",
          light_blue_cell("Signature"), ""
        ],
        [
          light_blue_cell("Print name"), args.prescriber_name,
          light_blue_cell("Print name"), ""
        ],
        [
          light_blue_cell("Date"), args.formatted_prescription_date,
          light_blue_cell("Date"), ""
        ],
        [
          light_blue_cell("Qualification / registration"), "",
          light_blue_cell("PO Number"), args.po_number
        ],
        [
          light_blue_cell("Hospital Address", rowspan: 2),
          { content: args.formatted_hospital_name_and_address, rowspan: 2 },
          light_blue_heading_cell(
            "FMC Pharmacist Check",
            colspan: 2,
            background_color: DARK_BLUE,
            text_color: WHITE
          )
        ],
        [
          "Sig\n\n\n",
          "Date"
        ]
      ],
      column_widths: { 0 => 130, 1 => 150, 2 => 130, 3 => TABLE_WIDTH - (130 + 150 + 130) },
      **table_styles
    )
  end
end
