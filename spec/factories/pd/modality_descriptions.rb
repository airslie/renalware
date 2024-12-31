FactoryBot.define do
  factory :pd_modality_description, class: "Renalware::PD::ModalityDescription" do
    initialize_with do
      Renalware::PD::ModalityDescription.find_or_create_by!(name: name)
    end
    name { "PD" }
    code { "pd" }
  end
end
