# frozen_string_literal: true

FactoryBot.define do
  factory :research_investigatorship, class: "Renalware::Research::Investigatorship" do
    association :study, factory: :research_study
    association :user
    started_on { "201-01-01" }
    association :created_by, factory: :user
    association :updated_by, factory: :user
  end
end
