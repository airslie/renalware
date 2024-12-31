FactoryBot.define do
  sequence(:term) { |n| "term-#{n}" }
  factory :peritonitis_episode_type_description,
          class: "Renalware::PD::PeritonitisEpisodeTypeDescription" do
    term
    definition { Faker::Lorem.sentence }
  end
end
