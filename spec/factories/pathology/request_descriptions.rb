FactoryBot.define do
  factory :pathology_request_description, class: "Renalware::Pathology::RequestDescription" do
    initialize_with {
      Renalware::Pathology::RequestDescription.find_or_create_by!(code:) do |x|
        x.name = name
        x.lab = lab
      end
    }
    lab factory: %i(pathology_lab)
    code { "FBC" }
    name { "FBC" }

    trait :serum do
      bottle_type { "serum" }
    end

    trait :with_required_observation_description do
      required_observation_description factory: :pathology_observation_description
    end
  end
end
