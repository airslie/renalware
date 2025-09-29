# frozen_string_literal: true

class Forms::Fresenius::Homecare::PatientDetailsTable < Forms::Fresenius::Homecare::Base
  def build # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    font_size 9
    table(
      [
        [
          light_blue_heading_cell("PATIENT DETAILS", colspan: 4)
        ],
        [
          light_blue_cell("Title"),
          args.title,
          light_blue_cell("FMC Patient"),
          ""
        ],
        [
          light_blue_cell("Forename"),
          args.given_name,
          light_blue_cell("NHS Number"),
          args.nhs_number
        ],
        [
          light_blue_cell("Surname"),
          args.family_name,
          light_blue_cell("Hospital Number"),
          args.hospital_number
        ],
        [
          light_blue_cell("Date of Birth"),
          args.born_on&.to_s,
          light_blue_cell("Known Allergies / Sensitivities", rowspan: 4, font_style: :bold),
          cell_with_leading_checkbox(
            "No Known Drug Allergies",
            checked: args.no_known_allergies,
            rowspan: 1,
            font_style: :bold
          )
        ],
        [
          light_blue_cell("Telephone/Mobile"),
          args.telephone,
          known_allergies_cell
        ],
        [
          light_blue_cell("Address"),
          args.formatted_address
        ],
        [
          light_blue_cell("Postcode"),
          args.postcode
        ]
      ],
      column_widths: { 0 => 100, 1 => 210, 2 => 100, 3 => TABLE_WIDTH - (100 + 210 + 100) },
      **table_styles
    )
  end

  private

  def known_allergies_cell
    return { content: "", rowspan: 3 } if args.allergies.nil?

    allergies = Array(args.allergies).compact.uniq.join("<br>")
    {
      content: "<b><font name='ZapfDingbats'>#{CHECKBOX}</font>Yes please specify</b>" \
               "<br>#{allergies}",
      inline_format: true,
      rowspan: 3
    }
  end
end
