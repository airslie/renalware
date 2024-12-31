FactoryBot.define do
  factory :language, class: "Renalware::Patients::Language" do
    name { "English" }
    code { "en" }

    trait :english do
      name { "English" }
      code { "en" }
    end

    trait :afrikaans do
      name { "Afrikaans" }
      code { "af" }
    end

    trait :unknown do
      name { "Unknown" }
      code { "un" }
    end

    trait :other do
      name { "Other" }
      code { "ot" }
    end
  end
end
