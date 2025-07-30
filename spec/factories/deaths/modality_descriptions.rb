FactoryBot.define do
  factory :death_modality_description, class: "Renalware::Deaths::ModalityDescription" do
    initialize_with do
      Renalware::Deaths::ModalityDescription.find_or_create_by(name: "Death", code: "death")
    end
  end
end
