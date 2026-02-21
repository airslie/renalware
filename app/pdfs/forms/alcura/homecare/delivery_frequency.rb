# frozen_string_literal: true

class Forms::Alcura::Homecare::DeliveryFrequency < Forms::Alcura::Homecare::Base
  DEFAULT_DELIVERY_FREQS = [
    "Once",
    "4 weeks",
    "8 weeks",
    "12 weeks",
    "Other"
  ].freeze

  def build
    row_with_title_and_array_of_checkbox_options(
      title: "Delivery Frequency",
      options: DEFAULT_DELIVERY_FREQS
    )
  end
end
