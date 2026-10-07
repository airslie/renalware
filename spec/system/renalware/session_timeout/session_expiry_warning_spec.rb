# Time is frozen and then advanced rather than waited for: in the browser with Playwright's clock
# (which drives session_controller.js timers) and on the server with travel (which Devise uses).
describe "Warning before the session expires", :js do
  around do |example|
    original_timeout = Devise.timeout_in
    original_warning = Renalware.config.session_timeout_warning
    original_activity = Renalware.config.session_register_user_user_activity_after

    Devise.timeout_in = 20.minutes
    Renalware.config.session_timeout_warning = 2.minutes
    Renalware.config.session_register_user_user_activity_after = 2.minutes

    example.run
  ensure
    Devise.timeout_in = original_timeout
    Renalware.config.session_timeout_warning = original_warning
    Renalware.config.session_register_user_user_activity_after = original_activity
  end

  let(:warning) { "dialog[open]" }
  let(:until_warning) { 18.minutes + 1.second }
  let(:past_original_expiry) { 2.minutes + 5.seconds }

  before do
    freeze_time
    browser do |playwright_page|
      playwright_page.clock.install(time: Time.current)
      playwright_page.clock.pause_at(Time.current)
    end
    login_as_clinical
    visit root_path
    page.execute_script("window.notReloaded = true")
  end

  def browser(&) = page.driver.with_playwright_page(&)

  def advance(duration)
    travel(duration)
    run_browser_clock_for(duration)
  end

  def run_browser_clock_for(duration)
    browser { |playwright_page| playwright_page.clock.run_for(duration.in_milliseconds.to_i) }
  end

  def choose_to_stay_signed_in
    awaiting_keep_alive { within(warning) { click_on "Stay signed in" } }
  end

  def awaiting_keep_alive(&)
    browser { |playwright_page| playwright_page.expect_response(/keep_session_alive/, &) }
  end

  def expect_user_still_on_the_page
    expect(page).to have_current_path(root_path)
    expect(page.evaluate_script("window.notReloaded")).to be(true)
  end

  it "warns the user with a countdown shortly before their session expires" do
    advance(until_warning - 2.seconds)
    expect(page).to have_no_css(warning)

    advance(2.seconds)

    within(warning) do
      expect(page).to have_text("Your session is about to expire")
      expect(page).to have_text(/You will be logged out in 1:5\d/)
    end
  end

  it "keeps the user signed in when they choose to stay signed in" do
    advance(until_warning)

    choose_to_stay_signed_in

    expect(page).to have_no_css(warning)
    advance(past_original_expiry)
    expect_user_still_on_the_page
  end

  it "keeps the user signed in when they dismiss the warning with Escape" do
    advance(until_warning)
    expect(page).to have_css(warning)

    awaiting_keep_alive { page.send_keys(:escape) }

    expect(page).to have_no_css(warning)
    advance(past_original_expiry)
    expect_user_still_on_the_page
  end

  it "does not reload the page when the server is slow to confirm the user is staying signed in" do
    advance(Devise.timeout_in - 1.second)
    expect(page).to have_css(warning)
    respond_to_keep_alive_after_the_browser_clock_passes(5.seconds)

    choose_to_stay_signed_in

    expect(page).to have_no_css(warning)
    expect_user_still_on_the_page
  end

  def respond_to_keep_alive_after_the_browser_clock_passes(duration)
    delayed_response = lambda { |route, _request|
      Thread.new do
        response = route.fetch
        run_browser_clock_for(duration)
        route.fulfill(response:)
      end
    }
    browser { |playwright_page| playwright_page.route("**/keep_session_alive*", delayed_response) }
  end

  it "signs the user out if they ignore the warning" do
    advance(until_warning)
    expect(page).to have_css(warning)

    advance(past_original_expiry)

    expect(page).to have_current_path(new_user_session_path)
    expect(page).to have_text("Your session expired")
  end

  it "does not warn a user who has been active since the session was last extended" do
    advance(until_warning - 30.seconds)
    find("main").click

    awaiting_keep_alive { advance(30.seconds) }

    expect(page).to have_no_css(warning)
    advance(past_original_expiry)
    expect_user_still_on_the_page
  end
end
