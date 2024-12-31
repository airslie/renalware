begin
  require "database_cleaner"
  require "database_cleaner/cucumber"

  DatabaseCleaner.strategy = if ENV["TEST_DEPTH"] == "web"
                               :deletion
                             else
                               :transaction
                             end
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in :test group) if you wish to use it."
end

Around do |_scenario, block|
  DatabaseCleaner.cleaning(&block)
end
