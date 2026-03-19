# Add your own tasks in files placed in lib/tasks ending in .rake.

puts "Loading app rake tasks"

require_relative "config/application"
Rails.application.load_tasks

# Default rake task to run all tests:
#   bundle exec rake
desc "Default"
task :default do
  sh "bin/rspec"
  sh "bin/cucumber"
  sh "bin/cucumber TEST_DEPTH=web --profile rake_web"
end
