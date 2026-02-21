# frozen_string_literal: true

class Forms::Alcura::Homecare::Heading < Forms::Alcura::Homecare::Base
  def build
    image(
      Renalware::Engine.root.join("app/assets/images/renalware/alcura_logo.png"),
      width: 200,
      at: [20, 800]
    )
    font_size 12
    bounding_box([300, 797], width: 250) do
      text "PRESCRIPTION REQUIREMENTS", style: :bold, align: :center
      text "Generic Immunosuppressants", style: :bold, align: :center
      text "PRIVATE & CONFIDENTIAL", style: :bold, align: :center
    end
    move_down 5
  end
end
