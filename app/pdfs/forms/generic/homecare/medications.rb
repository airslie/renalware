# frozen_string_literal: true

class Forms::Generic::Homecare::Medications < Forms::Base
  def build # rubocop:disable Metrics/MethodLength
    move_down 20
    font_size 10

    rows = []
    rows << [
      heading("Date"),
      heading("Drug"),
      heading("Dose"),
      heading("Route"),
      heading("Freq"),
      heading("Pharmacy comments")
    ]

    args.medications.map do |med|
      rows << [
        med.date.to_s,
        med.drug,
        med.dose,
        med.route,
        med.frequency,
        ""
      ]
    end

    table(
      rows,
      column_widths: {
        0 => 60,
        1 => 140,
        2 => 80,
        3 => 75,
        4 => 75,
        5 => 110
      },
      **table_styles,
      **underlined_table_style
    )
  end
end
