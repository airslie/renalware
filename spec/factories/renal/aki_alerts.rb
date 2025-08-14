FactoryBot.define do
  factory :aki_alert, class: "Renalware::Renal::AKIAlert" do
    patient factory: :renal_patient
    accountable
    notes { "Some notes" }
    hotlist { false }
    action factory: %i(aki_alert_action)
    hospital_ward
  end
end
