FactoryBot.define do
  factory :hospital_centre, class: "Renalware::Hospitals::Centre" do
    initialize_with do
      Renalware::Hospitals::Centre.find_or_create_by!(code:, name:)
    end

    name { "Dover Hospital" }
    code { "DOV" }
    host_site { true }

    trait :default do
      default_site { true }
      host_site { true }
      active { true }
    end
  end
end
