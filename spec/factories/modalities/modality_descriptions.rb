FactoryBot.define do
  factory :modality_description, class: "Renalware::Modalities::Description" do
    name { "unspecific modality description not set in factory" }
    hidden { false }

    initialize_with { Renalware::Modalities::Description.find_or_create_by(name: name) }

    trait :transfer_out do
      name { "Transfer Out" }
      code { "transfer_out" }
    end

    trait :pd do
      name { "PD" }
      type { "Renalware::PD::ModalityDescription" }
      code { "pd" }
    end

    trait :hd do
      name { "HD" }
      type { "Renalware::HD::ModalityDescription" }
      code { "hd" }
    end

    trait :hd do
      name { "HD" }
      type { "Renalware::HD::ModalityDescription" }
      code { "hd" }
    end

    trait :transplant do
      name { "Transplant" }
      type { "Renalware::Transplants::RecipientModalityDescription" }
      code { "transplant" }
    end

    trait :low_clearance do
      name { "Advanced Kidney Care" }
      type { "Renalware::LowClearance::ModalityDescription" }
      code { "low_clearance" }
    end

    trait :akcc do
      name { "Advanced Kidney Care" }
      type { "Renalware::LowClearance::ModalityDescription" }
      code { "low_clearance" }
    end

    trait :death do
      name { "Death" }
      type { "Renalware::Deaths::ModalityDescription" }
      code { "death" }
    end

    trait :live_donor do
      name { "Live Donor" }
      type { "Renalware::Transplants::DonorModalityDescription" }
      code { "live_donor" }
    end

    trait :aki do
      name { "AKI" }
      code { "aki" }
    end

    trait :nephrology do
      name { "Nephrology" }
      code { "nephrology" }
    end
  end
end
