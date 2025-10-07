# frozen_string_literal: true

FactoryBot.define do
  factory :ukrdc_assessment_type, class: "Renalware::UKRDC::Assessments::Type" do
    initialize_with { Renalware::UKRDC::Assessments::Type.find_or_create_by(code:) }

    code { "TPLTassess" }
    description { "Suitability for renal transplant" }

    trait :tpl do
      code { "TPLTassess" }
      description { "Suitability for renal transplant" }
    end

    trait :rrt do
      code { "RRTassess" }
      description { "Shared future RRT choice" }
    end

    trait :ppd do
      code { "PPDassess" }
      description { "Preferred place of dying" }
    end
  end
end
