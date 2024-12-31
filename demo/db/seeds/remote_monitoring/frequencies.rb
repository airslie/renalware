module Renalware
  Rails.benchmark "Adding Remote Monitoring frequencies" do
    RemoteMonitoring::Frequency.find_or_create_by!(period: 4.months)
    RemoteMonitoring::Frequency.find_or_create_by!(period: 6.months)
    RemoteMonitoring::Frequency.find_or_create_by!(period: 12.months)
  end
end
