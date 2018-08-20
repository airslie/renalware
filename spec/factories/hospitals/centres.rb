# frozen_string_literal: true

FactoryBot.define do
  factory :hospital_centre, class: "Renalware::Hospitals::Centre" do
    name { "King's College Hospital" }
    code { "RJZ" }
  end
end
