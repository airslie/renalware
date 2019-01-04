# frozen_string_literal: true

FactoryBot.define do
  factory :research_membership, class: "Renalware::Research::Membership" do
    association :study, factory: :research_study
    association :user
    association :hospital_centre
    association :created_by, factory: :user
    association :updated_by, factory: :user
  end
end
