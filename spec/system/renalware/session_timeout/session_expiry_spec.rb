describe "Session timeout", :js do
  around do |example|
    original_session_timeout = Devise.timeout_in
    # see session_controller.js - we set the session timeout to be almost in the past
    # because we add an 10 second buffer in that file.
    Devise.timeout_in = -8.seconds

    example.run

    Devise.timeout_in = original_session_timeout
  end

  def configure_fast_expiry_with_buffer
    # Use a short timeout so we can verify activity extends the session window.
    Devise.timeout_in = 4.seconds
    Renalware.config.session_register_user_user_activity_after = 1.second
  end

  it "A user is redirected by JS to the login page when their session expires" do
    Renalware.config.session_register_user_user_activity_after = 2.seconds
    login_as_clinical

    visit root_path

    expect(page).to have_current_path(root_path)

    expect(page).to have_current_path(new_user_session_path, wait: 20.seconds)
  end

  it "restarts the session window when the user clicks the page" do
    configure_fast_expiry_with_buffer
    login_as_clinical
    visit root_path

    # Activity before server timeout should keep the user on the page beyond the
    # original 4 second window.
    sleep 2
    find("main").click

    sleep 3
    expect(page).to have_current_path(root_path, wait: 2.seconds)
  end

  it "restarts the session window when the user presses a key" do
    configure_fast_expiry_with_buffer
    login_as_clinical
    visit root_path

    sleep 2
    page.execute_script(
      "document.dispatchEvent(new KeyboardEvent('keydown', { key: 'x', bubbles: true }))"
    )

    sleep 3
    expect(page).to have_current_path(root_path, wait: 2.seconds)
  end
end
