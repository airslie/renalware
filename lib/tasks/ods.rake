require "nhs_api_client"

namespace :ods do
  desc "Use the NHS Organisation Data Service (ODS) API to fetch updates to practices and GPs"
  task sync: :environment do
    Renalware::Patients::SyncODSJob.perform_later(dry_run: ENV["dry_run"] == "true")
  end
end
