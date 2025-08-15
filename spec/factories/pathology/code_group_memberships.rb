FactoryBot.define do
  factory :pathology_code_group_membership, class: "Renalware::Pathology::CodeGroupMembership" do
    accountable
    code_group { association :pathology_code_group }
    observation_description { association :pathology_observation_description }

    trait :ltax do
      observation_description { association :pathology_observation_description, :ltax }
      subgroup { 1 }
      position_within_subgroup { 1 }
    end

    trait :cya do
      observation_description { association :pathology_observation_description, :cya }
      subgroup { 1 }
      position_within_subgroup { 2 }
    end
  end
end
