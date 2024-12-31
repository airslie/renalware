FactoryBot.define do
  factory :live_donor_modality_description,
          class: "Renalware::Transplants::DonorModalityDescription" do
    name { "Live Donor" }
  end
end
