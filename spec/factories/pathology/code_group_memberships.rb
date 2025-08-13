FactoryBot.define do
  factory :pathology_code_group_membership, class: "Renalware::Pathology::CodeGroupMembership" do
    accountable
    code_group { association :pathology_code_group }
    observation_description { association :pathology_observation_description }
  end
end
