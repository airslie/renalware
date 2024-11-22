# frozen_string_literal: true

FactoryBot.define do
  factory :snippet, class: "Renalware::Authoring::Snippet" do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
  end
end
