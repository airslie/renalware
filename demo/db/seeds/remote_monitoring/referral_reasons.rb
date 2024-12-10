# frozen_string_literal: true

module Renalware
  log "Adding Remote Monitoring referral reasons" do
    ["APKD", "IGA Neph", "CKD Monitoring", "Glu Neph Monitoring"].each do |desc|
      RemoteMonitoring::ReferralReason.find_or_create_by!(description: desc)
    end
  end
end
