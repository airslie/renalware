Given("Clyde is on Patty's event index") do
  visit patient_events_path(@patty)
end

When("Clyde chooses to add an event") do
  click_on t("btn.add")
end

When("records Patty's event") do
  within "#new_events_event" do
    slim_select "Email", from: "Event type"
    fill_in_date_time "Date time", with: fake_date_time
    find_by_id("events_event_date_time").send_keys(:escape) # dismiss datepicker which has popped up
    wait_for_ajax
    # This is bound to fail sporadically, as the select fetches an update
    # of the page, which updates the inputs, but nothing really visible
    # changes. Only way to sort of prevent it is by adding a small sleep
    sleep 0.1
    fill_in "Description", with: "Discussed meeting to be set up with family."
    fill_trix_editor with: "Patty to speak to family before meeting set up."

    expect {
      # click_on t("btn.create")
      submit_form
    }.to change(Renalware::Events::Event, :count).by(1)
  end
end

Then("Clyde should see Patty's new event on the events page") do
  expect(page).to have_current_path(patient_events_path(@patty))
  expect(page).to have_content(l(fake_date))
  expect(page).to have_content(fake_time)
  expect(page).to have_content("Email")
  expect(page).to have_content("Discussed meeting to be set up with family.")
  click_on t("btn.toggle")
  expect(page).to have_content("Patty to speak to family before meeting set up.")
end

Then("see Patty's new event in her event index") do
  visit patient_events_path(@patty)

  expect(page).to have_content(l(fake_date))
  expect(page).to have_content(fake_time)
  expect(page).to have_content("Email")
  expect(page).to have_content("Discussed meeting to be set up with family.")
  click_on t("btn.toggle")
  expect(page).to have_content("Patty to speak to family before meeting set up.")
end
