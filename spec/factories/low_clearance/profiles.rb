FactoryBot.define do
  factory :low_clearance_profile, class: "Renalware::LowClearance::Profile" do
    accountable
    patient { association(:low_clearance_patient, by: accountable_actor) }
  end
end
