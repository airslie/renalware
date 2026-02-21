# frozen_string_literal: true

class Forms::Alcura::Homecare::PrescriptionDuration < Forms::Alcura::Homecare::Base
  def build
    row_with_title_and_array_of_checkbox_options(
      title: "Duration of Prescription",
      options: args.prescription_durations,
      selected_option: args.selected_prescription_duration
    )
  end
end
