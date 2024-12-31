FactoryBot.define do
  factory :research_investigatorship, class: "Renalware::Research::Investigatorship" do
    study factory: %i(research_study)
    user
    started_on { "201-01-01" }
    created_by factory: %i(user)
    updated_by factory: %i(user)
  end
end
