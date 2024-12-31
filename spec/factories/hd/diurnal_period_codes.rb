FactoryBot.define do
  factory :hd_diurnal_period_code, class: "Renalware::HD::DiurnalPeriodCode" do
    initialize_with { Renalware::HD::DiurnalPeriodCode.find_or_create_by(code: code) }
    code { "am" }

    trait :am do
      code { "am" }
    end

    trait :pm do
      code { "pm" }
    end

    trait :eve do
      code { "eve" }
    end
  end
end
