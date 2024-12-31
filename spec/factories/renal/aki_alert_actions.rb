FactoryBot.define do
  factory :aki_alert_action, class: "Renalware::Renal::AKIAlertAction" do
    name { SecureRandom.uuid }
  end
end
