FactoryBot.define do
  factory :pathology_observation, class: "Renalware::Pathology::Observation" do
    description factory: %i(pathology_observation_description)
    result { "6.0" }
    comment { "My Comment" }
    observed_at { "2016-03-04 10:15:40" }
  end
end
