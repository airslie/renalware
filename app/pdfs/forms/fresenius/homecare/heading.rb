# frozen_string_literal: true

class Forms::Fresenius::Homecare::Heading < Forms::Fresenius::Homecare::Base
  def build
    image(
      Renalware::Engine.root.join("app/assets/images/renalware/fresenius_logo.jpg"),
      width: 200,
      at: [0, 810]
    )
    font_size 12
    bounding_box([65, 750], width: 500) do
      text "Private and confidential", style: :bold
      text "Patient Aranesp® Prescription - Homecare Supply", style: :bold
    end
  end
end
