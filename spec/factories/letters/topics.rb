FactoryBot.define do
  factory :letter_topic, class: "Renalware::Letters::Topic" do
    sequence(:text) { |n| "Text#{n}" }
  end
end
