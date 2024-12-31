require "turnip/capybara"

# If a feature has the @web tag and ENV['TURNIP_WEB'] is something, then #web_steps will
# define and include a new anonymous module and put into it anything methods defined
# in the block.
module WebSteps
  def web_steps(&block)
    return unless ENV.key?("TURNIP_WEB")

    tag = :web
    Module.new do
      singleton_class.send(:define_method, :tag) { tag }
      module_eval(&block)
      ::RSpec.configure { |c| c.include self, tag => true }
    end
  end
end

# Some modules e.g. UserRoleSteps are included in other modules on demand to
# make composition clearer. Might be useful to document the inheritence tree here.
# A problem we have is that for @web tagged features we need to include once for domain-level
# specs and once @web - ie our original cucumber features had Domain and Web worlds and
# we used to run both separately.
#
# In the RSpec docs this is how you can run rspec multiple times in the same process
# require 'rspec/core'
# RSpec::Core::Runner.run(['spec'])
# RSpec.clear_examples
# RSpec::Core::Runner.run(['spec', '--require', 'somefile_to_wire_up_web_modules.rb'])
#
# Or perhaps could do this inbetween runs
# RSpec.configure { |c| c.add_setting :custom_setting }

if ENV.key?("TURNIP_WEB")
  Capybara.javascript_driver = :rw_headless_chrome
  Capybara::Screenshot.register_driver(:rw_headless_chrome) do |driver, path|
    driver.browser.save_screenshot(path)
  end
  if RUBY_PLATFORM.include?("darwin")
    require "capybara-screenshot/rspec"
  end
end

Dir.glob("spec/acceptance/renalware/steps/**/*steps.rb") do |file|
  require Renalware::Engine.root.join(file)
end

RSpec.configure do |config|
  config.raise_error_for_unimplemented_steps = true
  config.include Renalware::UserRoleSteps
  config.include Renalware::PatientSteps
  config.include Renalware::PatientSteps
  config.include Renalware::Accesses::AccessSteps
  config.include Renalware::Accesses::AccessAssessmentSteps
  config.include Renalware::Accesses::AccessProcedureSteps
  config.include Renalware::Accesses::AccessProfileSteps
  config.include Renalware::Clinical::AllergySteps
  config.include Renalware::Transplants::TransplantSteps
  config.include Renalware::Transplants::WaitListRegistrationSteps
end
