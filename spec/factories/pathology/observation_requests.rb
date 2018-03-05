# frozen_string_literal: true

FactoryBot.define do
  factory :pathology_observation_request, class: "Renalware::Pathology::ObservationRequest" do
    association :description, factory: :pathology_request_description
    requestor_order_number "123"
    requestor_name "Jane Doe"
    requested_at { 1.year.ago }

    trait :full_blood_count_with_observations do
      association :description, factory: :pathology_request_description, code: "FBC"
      after(:create) do |request|
        %w(WBC HGB PLT).each do |obx_code|
          desc = create(:pathology_observation_description, code: obx_code)
          create(
            :pathology_observation,
            description: desc,
            request: request,
            observed_at: request.requested_at
          )
        end
      end
    end

    trait :renal_live_urea_with_observations do
      association :description, factory: :pathology_request_description, code: "RLU"
      after(:create) do |request|
        %w(NA POT URE).each do |obx_code|
          desc = create(:pathology_observation_description, code: obx_code)
          create(
            :pathology_observation,
            description: desc,
            request: request,
            observed_at: request.requested_at,
            result: 1.0
          )
        end
      end
    end
  end
end
