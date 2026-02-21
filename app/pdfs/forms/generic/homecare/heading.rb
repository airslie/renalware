# frozen_string_literal: true

class Forms::Generic::Homecare::Heading < Forms::Base
  def build # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    move_down 10
    font_size 12
    text "PO: #{args.po_number}"
    font_size 8
    text "RW ref: #{args.hospital_number}"
    text "Drugs types: #{args.drug_type}"
    move_down 30
    font_size 16
    text "Home Delivery Medication List", style: :bold
    font_size 8
    text "As at #{args.generated_at}"
    image(
      Renalware::Engine.root.join("app/assets/images/renalware/nhs_logo.jpg"),
      width: 60,
      at: [490, 800]
    )
    font_size 10
    text_box args.formatted_hospital_address, at: [350, 765], width: 200, align: :right
  end
end
