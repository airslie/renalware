FactoryBot.define do
  factory :system_nag_definition, class: "Renalware::System::NagDefinition" do
    description { Faker::Lorem.sentence }
    title { Faker::Lorem.word }
    hint { Faker::Lorem.sentence }
    importance { 1 }
    scope { :patient }
    sql_function_name { "abc" }

    factory :patient_nag_definition do
      scope { :patient }

      trait :clinical_frailty_score do
        sql_function_name { "patient_nag_clinical_frailty_score" }
      end

      trait :hd_dna do
        sql_function_name { "patient_nag_hd_dna" }
      end
    end

    factory :user_nag_definition do
      scope { :patient }
    end
  end
end
