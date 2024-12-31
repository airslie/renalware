FactoryBot.define do
  factory :donor_stage_position, class: "Renalware::Transplants::DonorStagePosition" do
    name { SecureRandom.hex(20) }
  end
end
