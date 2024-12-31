FactoryBot.define do
  factory :ethnicity, class: "Renalware::Patients::Ethnicity" do
    name { "White - British" }
    rr18_code { "A" }
    cfh_name { "White" }

    trait :white_british do
      name { "White - British" }
      rr18_code { "A" }
      cfh_name { "White" }
    end

    trait :black_caribbean do
      name { "Black Caribbean" }
      rr18_code { "M" }
      cfh_name { "Black" }
    end
  end
end
