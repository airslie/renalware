# frozen_string_literal: true

class Forms::Fresenius::Homecare::PrescriptionsTable < Forms::Fresenius::Homecare::Base
  def build # rubocop:disable Metrics/MethodLength
    move_down 5
    med = args.medications.first || Forms::Homecare::Args::Medication.new

    table(
      [
        [
          light_blue_heading_cell("PRESCRIPTION", colspan: 3)
        ],
        [
          light_blue_cell("Medicine and Strength"),
          { content: "#{med.drug} #{med.dose}", colspan: 2 }
        ],
        [
          light_blue_cell("Device"),
          args.administration_device
        ],
        [
          light_blue_cell("Administration Frequency"),
          med.frequency,
          "If other"
        ],
        [
          light_blue_cell("Route"),
          med.route,
          "If other"
        ],
        [
          light_blue_cell("Prescription duration"),
          args.selected_prescription_duration,
          "If Other please specify"
        ]
      ],
      column_widths: { 0 => 150, 1 => 150, 2 => TABLE_WIDTH - (150 + 150) },
      **table_styles
    )
  end
end
