Capybara.register_driver(:rw_headless_chrome) do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("window-size=1366,1768")
  options.add_argument("headless")
  options.add_argument("disable-gpu")
  options.add_argument("disable-extensions")
  options.add_preference(:download, prompt_for_download: false)
  options.add_preference(:download, default_directory: Rails.root.join("tmp"))
  options.add_argument("no-sandbox")
  options.add_argument("enable-features=NetworkService,NetworkServiceInProcess")

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options
  )
end

unless ENV.key?("SEMAPHORECI")
  Capybara::Screenshot.register_driver(:rw_headless_chrome) do |driver, path|
    driver.browser.save_screenshot(path)
  end
end

Capybara.javascript_driver = :rw_headless_chrome
