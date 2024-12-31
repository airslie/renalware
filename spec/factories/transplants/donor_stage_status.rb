FactoryBot.define do
  factory :donor_stage_status, class: "Renalware::Transplants::DonorStageStatus" do
    name { SecureRandom.hex(20) }
  end
end
