FactoryBot.define do
  factory :death_location, class: "Renalware::Deaths::Location" do
    initialize_with { Renalware::Deaths::Location.find_or_create_by!(name: name) }
    name { "Hospital" }
    rr_outcome_code { 14 }
    rr_outcome_text { "Hospital" }

    trait :home do
      name { "Home" }
      rr_outcome_code { 11 }
      rr_outcome_text { "Current Home" }
    end

    trait :nursing_home do
      name { "Nursing Home" }
      rr_outcome_code { 12 }
      rr_outcome_text { "Nursing Home" }
    end

    trait :hospice do
      name { "Hospice" }
      rr_outcome_code { 13 }
      rr_outcome_text { "Hospice" }
    end

    trait :hospital do
      name { "Hospital" }
      rr_outcome_code { 14 }
      rr_outcome_text { "Hospital" }
    end

    trait :other do
      name { "Other" }
      rr_outcome_code { 15 }
      rr_outcome_text { "Other" }
    end
  end
end
