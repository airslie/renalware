FactoryBot.define do
  factory :pathology_chart_series, class: "Renalware::Pathology::Charts::Series" do
    chart factory: %i(pathology_chart)
    observation_description factory: %i(pathology_observation_description)
  end
end
