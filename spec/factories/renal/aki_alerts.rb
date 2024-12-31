FactoryBot.define do
  factory :aki_alert, class: "Renalware::Renal::AKIAlert" do
    accountable
    notes { "Some notes" }
    hotlist { false }
    action factory: %i(aki_alert_action)
    hospital_ward
  end
end
