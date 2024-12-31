FactoryBot.define do
  factory :remote_monitoring_frequency, class: "Renalware::RemoteMonitoring::Frequency" do
    period { 4.months }

    trait :"4M" do
      period { 4.months }
    end
  end
end
