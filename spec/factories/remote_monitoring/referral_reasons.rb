FactoryBot.define do
  factory :remote_monitoring_referral_reason,
          class: "Renalware::RemoteMonitoring::ReferralReason" do
    description { "CKD Monitoring" }
  end
end
