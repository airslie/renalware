FactoryBot.define do
  factory :clinic, class: "Renalware::Clinics::Clinic" do
    sequence :code do |n|
      "C#{n}"
    end

    sequence :name do |n|
      "Access#{n}"
    end

    trait :dietetic do
      name { "Dietetic" }
      visit_class_name { "Renalware::Dietetics::ClinicVisit" }
    end
  end
end
