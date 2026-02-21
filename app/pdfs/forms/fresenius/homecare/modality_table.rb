# frozen_string_literal: true

class Forms::Fresenius::Homecare::ModalityTable < Forms::Fresenius::Homecare::Base
  def build # rubocop:disable Metrics/MethodLength
    move_down 5
    table(
      [
        [
          light_blue_heading_cell("PATIENT STATUS", colspan: 3)
        ],
        [
          light_blue_cell("Modality"),
          args.modality,
          {
            content: "When treatment is <b>withheld</b> or <b>stopped</b> do not complete " \
                     "prescription section",
            inline_format: true
          }
        ]
      ],
      column_widths: { 0 => 150, 1 => 150, 2 => TABLE_WIDTH - (150 + 150) },
      **table_styles
    )
  end
end
