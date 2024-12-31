namespace :letters do
  desc "Remove stale files created during batch letter processing"
  task housekeeping: :environment do
    Renalware::Letters::Housekeeping::RemoveStaleFiles.call
  end
end
