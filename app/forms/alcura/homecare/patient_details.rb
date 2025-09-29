# frozen_string_literal: true

class Forms::Alcura::Homecare::PatientDetails < Forms::Alcura::Homecare::Base
  def build # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    move_down 5
    table(
      [
        [
          green_heading_cell("PATIENT DETAILS", colspan: 4)
        ],
        [
          heading("First Name"),
          args.given_name,
          heading("Date of Birth"),
          args.born_on
        ],
        [
          heading("Surname"),
          args.family_name,
          heading("Telephone"),
          args.telephone
        ],
        [
          heading("Address", rowspan: 4),
          { content: args.formatted_address_and_postcode, rowspan: 4 },
          heading("Hospital Number"),
          args.hospital_number
        ],
        [
          heading("NHS Number"),
          args.nhs_number
        ],
        [
          heading("Allergies / Sensitivities"),
          {
            content: allergies, inline_format: true
          }
        ],
        [
          heading("Weight (if applicable)"),
          ""
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

  private

  def allergies
    return "" if args.allergies.nil?

    arr = Array(args.allergies).uniq.compact.join("<br>")
    arr.prepend("No Known Allergies") if args.no_known_allergies == true
    arr
  end
end
