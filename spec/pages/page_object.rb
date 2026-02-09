module Pages
  class PageObject
    include Capybara::DSL
    include RSpec::Matchers
    include Rails.application.routes.url_helpers
    include ActionView::Helpers::TranslationHelper
    include FormHelpers
  end
end
