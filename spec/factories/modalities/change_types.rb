FactoryBot.define do
  factory :modality_change_type, class: "Renalware::Modalities::ChangeType" do
    initialize_with { Renalware::Modalities::ChangeType.find_or_create_by(code: code) }

    accountable
    code { "code" }
    name { "Name" }
    require_source_hospital_centre { false }
    require_destination_hospital_centre { false }

    trait :haemodialysis_to_pd do
      code { "haemodialysis_to_pd" }
      name { "Haemodialysis To PD" }
    end

    trait :pd_to_haemodialysis do
      code { "pd_to_haemodialysis" }
      name { "PD To Haemodialysis" }
    end

    trait :other do
      code { "other" }
      name { "Other" }
      default { true }
    end

    trait :default do
      code { "default" }
      name { "Default" }
      default { true }
    end

    trait :transferred_in do
      code { "transferred_in" }
      name { "Transferred in" }
      require_source_hospital_centre { true }
    end

    trait :transferred_out do
      code { "transferred_out" }
      name { "Transferred out" }
      require_destination_hospital_centre { true }
    end
  end
end
