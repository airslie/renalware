FactoryBot.define do
  factory :episode_type, class: "Renalware::PD::EpisodeType" do
    term { "De novo" }
    definition { "First infection." }
  end
end
