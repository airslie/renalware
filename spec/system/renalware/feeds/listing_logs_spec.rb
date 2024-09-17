# frozen_string_literal: true

describe "Feed Log messages" do
  it "lists them" do
    login_as_super_admin
    Renalware::Feeds::Log.create!(
      log_type: :close_match,
      log_reason: :number_hit_dob_miss,
      patient: create(:patient, family_name: "Jones", given_name: "Jack")
    )

    visit feeds_logs_path

    expect(page).to have_content("Feed Log Message")
    expect(page).to have_content("JONES, Jack")
  end
end
