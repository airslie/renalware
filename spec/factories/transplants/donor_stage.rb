FactoryBot.define do
  factory :donor_stage, class: "Renalware::Transplants::DonorStage" do
    accountable
    patient
    stage_position factory: :donor_stage_position
    stage_status factory: :donor_stage_status
    started_on { -> { Time.zone.now } }
    notes { "Some notes" }
    terminated_on { nil }
  end
end
