# frozen_string_literal: true

FactoryBot.define do
  factory :admissions_consult, class: "Renalware::Admissions::Consult" do
    accountable
    patient { association(:patient, by: accountable_actor) }
    consult_site factory: %i(admissions_consult_site)
    consult_type { "x" }
    started_on { 2.days.ago }
    ended_on { nil }
    description { "Lorem ipsum dolor" }

    trait :active do
      ended_on { nil }
    end

    trait :inactive do
      ended_on { 1.day.ago }
    end
  end
end
