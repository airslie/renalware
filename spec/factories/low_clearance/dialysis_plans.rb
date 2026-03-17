FactoryBot.define do
  factory :low_clearance_dialysis_plan, class: "Renalware::LowClearance::DialysisPlan" do
    code { Faker::Code.npi }
    name { Faker::Name.name }

    trait :capd_la do
      code { "capd_la" }
      name { "CAPD LA" }
    end

    trait :hd do
      code { "hd" }
      name { "HD" }
    end
  end
end
