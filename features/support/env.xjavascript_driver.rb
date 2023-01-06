# frozen_string_literal: true

Capybara.register_driver(:rw_headless_chrome) do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    # This makes logs available, but doesn't cause them to appear
    # in real time on the console
    "goog:loggingPrefs": {
      browser: "ALL",
      client: "ALL",
      driver: "ALL",
      server: "ALL"
    }
  )

  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("window-size=1366,1768")
  options.add_argument("headless")
  options.add_argument("disable-gpu")

  options.add_argument("disable-extensions")
  # options.add_argument("disable-dev-shm-usage") # causes a chrome unreachable error on CI
  options.add_argument("no-sandbox")
  options.add_argument("enable-features=NetworkService,NetworkServiceInProcess")

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    capabilities: capabilities,
    options: options
  )
end

unless ENV.key?("SEMAPHORECI")
  Capybara::Screenshot.register_driver(:rw_headless_chrome) do |driver, path|
    driver.browser.save_screenshot(path)
  end
end

Capybara.javascript_driver = :rw_headless_chrome
