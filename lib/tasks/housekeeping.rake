#
# Housekeeping tasks for removing stale logs and archived files.
#
namespace :housekeeping do
  desc "Run all housekeeping tasks - UKRDC and our own"
  task all: ["ukrdc:housekeeping", "letters:housekeeping", "hd:housekeeping"]
end

desc "This is the default housekeeping task"
task housekeeping: "housekeeping:all"
