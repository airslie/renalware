FactoryBot.define do
  factory :survey, class: "Renalware::Surveys::Survey" do
    name { Faker::Lorem.word }
    code { Faker::Lorem.word }
    description { "description" }

    factory :eq5d_survey do
      name { "EQ5D" }
      code { "eq5d" }
      description { "Patient health status" }
    end

    factory :pos_s_survey do
      name { "PROM" }
      code { "prom" }
      description { "Patient health status" }
    end
  end

  factory :survey_question, class: "Renalware::Surveys::Question" do
    survey
    label { "label" }
    code { Faker::Lorem.word }
  end
end
