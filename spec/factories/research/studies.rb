FactoryBot.define do
  factory :research_study, class: "Renalware::Research::Study" do
    code { SecureRandom.hex(8) }
    description { "Description for #{code}" }
    leader { Faker::Name.name }
    started_on { 1.year.ago }
    terminated_on { nil }
    deleted_at { nil }
    accountable
  end
end
