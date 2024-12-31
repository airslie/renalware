FactoryBot.define do
  factory :pathology_chart, class: "Renalware::Pathology::Charts::Chart" do
    sequence :title do |n|
      "Chart #{n}"
    end
  end
end
