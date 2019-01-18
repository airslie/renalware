# frozen_string_literal: true

FactoryBot.define do
  factory :research_study_participation, class: "Renalware::Research::StudyParticipation" do
    association :study, factory: :research_study
    association :patient, factory: :patient
    joined_on { Time.zone.today }
  end
end
