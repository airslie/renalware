FactoryBot.define do
  factory :death_modality_description, class: "Renalware::Deaths::ModalityDescription" do
    initialize_with { Renalware::Deaths::ModalityDescription.find_or_create_by(name: "Death") }
  end
end
