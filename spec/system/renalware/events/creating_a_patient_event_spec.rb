RSpec.describe "Creating a patient event", :js do
  include DateHelpers

  let(:patient) { create(:patient) }
  let(:clinician) { create(:user, role: "clinical") }

  before do
    create(:event_type, name: "Email")
    login_as clinician
  end

  it "creates an event" do
    visit patient_events_path(patient)
    click_on t("btn.add")

    slim_select "Email", from: "Event type"

    within "#new_events_event" do
      fill_in "Date time", with: fake_date_time

      # escape dismisses datepicker which has popped up
      find_by_id("events_event_date_time").send_keys(:escape)
      fill_in "Description", with: "Discussed meeting to be set up with family."
      fill_trix_editor with: "Patty to speak to family before meeting set up."

      expect {
        # click_on t("btn.create")
        submit_form
      }.to change(Renalware::Events::Event, :count).by(1)
    end

    expect(page).to have_current_path(patient_events_path(patient))
    expect(page).to have_text(l(fake_date))
    expect(page).to have_text(fake_time)
    expect(page).to have_text("Email")
    expect(page).to have_text("Discussed meeting to be set up with family.")
    click_on t("btn.toggle")
    expect(page).to have_text("Patty to speak to family before meeting set up.")

    visit patient_events_path(patient)

    expect(page).to have_text(l(fake_date))
    expect(page).to have_text(fake_time)
    expect(page).to have_text("Email")
    expect(page).to have_text("Discussed meeting to be set up with family.")
    click_on t("btn.toggle")
    expect(page).to have_text("Patty to speak to family before meeting set up.")
  end
end
