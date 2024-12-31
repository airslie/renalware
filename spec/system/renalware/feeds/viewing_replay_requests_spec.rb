describe "Viewing Feed Replay Requests" do
  it do
    login_as_super_admin

    visit feeds_replay_requests_path

    expect(page).to have_content("Replay Requests")
  end
end
