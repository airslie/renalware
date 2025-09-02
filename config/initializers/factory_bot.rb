# Use FactoryBot.create :model, ... in Rails console.
# Use with rails c -s to ensure data is rolled back.
# Additionally use as RAILS_ENV=test rails c -s to avoid
# seed data conflicting with factory persistence.

if Rails.env.local? && defined?(Rails::Console)
  require "factory_bot_rails"
  require "faker"
  FactoryBot.find_definitions
end
