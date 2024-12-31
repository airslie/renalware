describe "Session timeout", :js do
  around do |example|
    original_session_timeout = Devise.timeout_in
    # see sessions_controller.js - we set the session timeout to be almost in the past
    # because we add an 10 second buffer in that file.
    Devise.timeout_in = -8.seconds

    example.run

    Devise.timeout_in = original_session_timeout
  end

  it "A user is redirected by JS to the login page when their session expires" do
    Renalware.config.session_timeout_polling_frequency = 1.second
    Renalware.config.session_register_user_user_activity_after = 2.seconds
    login_as_clinical

    visit root_path

    expect(page).to have_current_path(root_path)

    10.times do
      sleep 0.5
      break if page.current_path == new_user_session_path
    end

    # After a period of inactivity (Devise.timeout_in), expect to have been redirected
    # to the login page
    expect(page).to have_current_path(new_user_session_path)
  end

  it "restarts the session window when the user clicks the page"
  it "restarts the session window when the user presses a key"
end
