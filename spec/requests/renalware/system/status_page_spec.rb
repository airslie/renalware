describe "Renalware status page" do
  around do |example|
    # Use freeze_time here because we check e.g. last_login_at = now in tests
    # and we need time to stand still for this to work.
    freeze_time do
      logout # a Warden helper to undo the login_as that has already happened at this point
      example.run
    end
  end

  it "does not require a login in order to view the page" do
    get renalware.status_path

    expect(response).not_to be_redirect # ie no unauthorised with a redirect to login page
    expect(response).to be_successful
  end

  it "does not write to the database" do
    expect {
      get renalware.status_path
    }.not_to change(Renalware::System::Event, :count)
  end

  it "displays user activity" do
    get renalware.status_path

    # There will be one active user, caused by our implicit Warden login_as (and subsequent
    # logout above)
    now = I18n.l(Time.zone.now)
    expect(response.body).to include("User activity")
    expect(response.body).to include("<td>Last successful login</td><td>#{now}</td>")
    expect(response.body).to include("<td>Last activity</td><td>#{now}</td>")
    expect(response.body).to include("<td>Active users in the last 30 minutes</td><td>1</td>")
  end
end
