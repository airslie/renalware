FactoryBot.define do
  factory :low_clearance_modality_description,
          class: "Renalware::LowClearance::ModalityDescription" do
    initialize_with do
      Renalware::LowClearance::ModalityDescription.find_or_create_by(name: "Advanced Kidney Care")
    end
  end
end
