# frozen_string_literal: true

FactoryBot.define do
  factory :ukrdc_assessment_outcome, class: "Renalware::UKRDC::Assessments::Outcome" do
    initialize_with { Renalware::UKRDC::Assessments::Outcome.find_or_create_by(code:) }

    code { 11 }
    description { "Current home" }
    assessment_type factory: %i(ukrdc_assessment_type ppd)

    trait :home do
      code { 11 }
      description { "Current home" }
      assessment_type factory: %i(ukrdc_assessment_type ppd)
    end

    trait :nursing_home do
      code { 12 }
      description { "Nursing home" }
      assessment_type factory: %i(ukrdc_assessment_type ppd)
    end

    trait :hospice do
      code { 13 }
      description { "Hospice" }
      assessment_type factory: %i(ukrdc_assessment_type ppd)
    end

    trait :hospital do
      code { 14 }
      description { "Hospital" }
      assessment_type factory: %i(ukrdc_assessment_type ppd)
    end

    trait :other do
      code { 15 }
      description { "Other" }
      assessment_type factory: %i(ukrdc_assessment_type ppd)
    end

    trait :hd do
      code { 7 }
      description { "Opts for ICHD" }
      assessment_type factory: %i(ukrdc_assessment_type rrt)
    end

    trait :tx_suitable do
      code { 3 }
      description { "Suitable" }
      assessment_type factory: %i(ukrdc_assessment_type tpl)
    end

    trait :tx_workup do
      code { 2 }
      description { "Workup commenced" }
      assessment_type factory: %i(ukrdc_assessment_type tpl)
    end

    trait :tx_unsuitable do
      code { 1 }
      description { "Unsuitable" }
      assessment_type factory: %i(ukrdc_assessment_type tpl)
    end
  end
end
