# frozen_string_literal: true

class Forms::Alcura::Homecare::HospitalDetails < Forms::Alcura::Homecare::Base
  def build # rubocop:disable Metrics/MethodLength
    move_down 5
    table(
      [
        [
          green_heading_cell("HOSPITAL DETAILS", colspan: 4)
        ],
        [
          heading("Hospital Name"),
          args.hospital_name,
          heading("Department"),
          args.hospital_department
        ],
        [
          heading("Address", rowspan: 2),
          { content: args.formatted_hospital_address, rowspan: 2 },
          heading("Consultant"),
          args.consultant
        ],
        [
          heading("Telephone"),
          args.hospital_telephone
        ]
      ],
      column_widths: {
        0 => 100,
        1 => (TABLE_WIDTH - 200) / 2,
        2 => 100,
        3 => (TABLE_WIDTH - 200) / 2
      },
      **table_styles
    )
  end
end
