#
# Housekeeping tasks for removing stale logs and archived files.
#
require_relative "../database_housekeeping"

namespace :housekeeping do
  desc "Run all housekeeping tasks - UKRDC and our own"
  task all: [
    "ukrdc:housekeeping",
    "letters:housekeeping",
    "hd:housekeeping",
    :database
  ]

  desc "Clear old database records"
  task database: :environment do
    puts "Database housekeeping..."
    DatabaseHousekeeping.new.call
  end
end

desc "This is the default housekeeping task"
task housekeeping: "housekeeping:all"
