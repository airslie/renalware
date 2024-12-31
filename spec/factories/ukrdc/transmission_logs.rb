FactoryBot.define do
  factory :ukrdc_transmission_log, class: "Renalware::UKRDC::TransmissionLog" do
    sent_at { Time.zone.now }
    status { :queued }
  end
end
