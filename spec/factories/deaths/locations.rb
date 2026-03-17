FactoryBot.define do
  factory :death_location, class: "Renalware::Deaths::Location" do
    initialize_with { Renalware::Deaths::Location.find_or_create_by!(name:) }

    name { "Hospital" }
    ukrdc_assessment_outcome factory: %i(ukrdc_assessment_outcome hospital)

    trait :home do
      name { "Home" }
      ukrdc_assessment_outcome factory: %i(ukrdc_assessment_outcome home)
    end

    trait :nursing_home do
      name { "Nursing Home" }
      ukrdc_assessment_outcome factory: %i(ukrdc_assessment_outcome nursing_home)
    end

    trait :hospice do
      name { "Hospice" }
      ukrdc_assessment_outcome factory: %i(ukrdc_assessment_outcome hospice)
    end

    trait :hospital do
      name { "Hospital" }
      ukrdc_assessment_outcome factory: %i(ukrdc_assessment_outcome hospital)
    end

    trait :other do
      name { "Other" }
      ukrdc_assessment_outcome factory: %i(ukrdc_assessment_outcome other)
    end
  end
end
