# frozen_string_literal: true

FactoryBot.define do
  factory :modality, class: "Renalware::Modalities::Modality" do
    accountable
    patient
    association :description, factory: :modality_description
    association :reason, factory: :modality_reason
    started_on { Date.parse("2015-04-01") }

    trait :terminated do
      state { "terminated" }
    end

    trait :pd_to_haemo do
      after(:create) do |instance|
        instance.reason = create(:pd_to_haemodialysis)
      end
    end

    trait :haemo_to_pd_modality do
      after(:create) do |instance|
        instance.reason = create(:haemodialysis_to_pd)
      end
    end
  end
end
