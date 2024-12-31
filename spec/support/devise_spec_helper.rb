require "devise"
require_relative "login_macros"

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller

  %i(feature system request component).each do |type|
    config.include Warden::Test::Helpers, type: type
  end

  config.include Warden::Test::Helpers, type: :component
  config.include Devise::Test::IntegrationHelpers, type: :component
  config.include Devise::Test::IntegrationHelpers, type: :system

  %i(controller system feature request component).each do |type|
    config.include LoginMacros, type: type
  end

  config.before(:each, type: :controller) do
    login_as_super_admin
  end

  config.before(:each, type: :request) do
    login_as_super_admin
  end

  config.before :suite do
    Warden.test_mode!
  end

  config.after do
    Warden.test_reset!
  end
end

# This monkey patch is to allow Devise::ControllerHelpers to work with
# ActionView::Component::TestHelpers which does not expose @request or @controller.
module DeviseHelperAdditionsForActionViewComponent
  def setup_controller_for_warden
    if respond_to?(:request)
      @request ||= request
      @controller ||= controller
    end
    super
  end
end
Devise::Test::ControllerHelpers.prepend(DeviseHelperAdditionsForActionViewComponent)
