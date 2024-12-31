FactoryBot.define do
  factory :research_participation, class: "Renalware::Research::Participation" do
    study factory: %i(research_study)
    patient
    joined_on { Time.zone.today }
  end
end
