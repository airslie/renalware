FactoryBot.define do
  factory :clinic_visit_location, class: "Renalware::Clinics::VisitLocation" do
    name { "In clinic" }
    default_location { false }

    trait :clinic do
      name { "In clinic" }
      default_location { true }
    end

    trait :telephone do
      name { "By telephone" }
      default_location { false }
    end

    trait :teams do
      name { "Over Teams" }
      default_location { false }
    end
  end
end
