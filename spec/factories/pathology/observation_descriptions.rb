FactoryBot.define do
  factory :pathology_observation_description,
          class: "Renalware::Pathology::ObservationDescription" do
    initialize_with do
      Renalware::Pathology::ObservationDescription.find_or_create_by!(code: code)
    end

    before(:create) { |desc| desc.loinc_code ||= desc.code.downcase }

    code { "WBR" }
    measurement_unit factory: %i(pathology_measurement_unit)
    display_group { 1 }
    display_order { 1 }
    letter_group { 1 }
    letter_order { 1 }

    %i(urr ure hgb cre phos pth pthi).each do |code|
      trait code do
        code { code.to_s.upcase }
        name { code.to_s.upcase }
      end
    end
  end
end
