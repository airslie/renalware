# frozen_string_literal: true

describe "Viewing Message Replays" do
  let(:patient) { create(:patient) }

  it do
    login_as_super_admin
    replay_request = Renalware::Feeds::ReplayRequest.create!(
      patient: patient,
      started_at: 2.hours.ago,
      finished_at: 1.hour.ago
    )

    visit feeds_replay_request_message_replays_path(replay_request)

    expect(page).to have_content("Replayed Feed Messages")
  end
end
