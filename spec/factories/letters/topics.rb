# frozen_string_literal: true

FactoryBot.define do
  factory :letter_topic, class: "Renalware::Letters::Topic" do
    text { |n| "Clinic letter #{n}" }
  end
end
