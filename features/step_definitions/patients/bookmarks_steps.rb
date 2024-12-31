# GIVEN

Given("Clyde has the following patients bookmarked:") do |table|
  table.raw.flatten.map do |patient_name|
    create_bookmark(user: @clyde, patient_name: patient_name)
  end
end

Given("Doug bookmarked {word}") do |patient_name|
  create_bookmark(user: @doug, patient_name: patient_name)
end

# WHEN

When("Clyde bookmarks {word}") do |patient_name|
  bookmark_patient(user: @clyde, patient_name: patient_name)
end

When(/^Clyde bookmarks (\w+) with the note "([^"]*)" and indicates it is (urgent|not urgent)$/) do |patient_name, notes, urgent|
  bookmark_patient(user: @clyde,
                   patient_name: patient_name,
                   notes: notes,
                   urgent: urgent == "urgent")
end

When("Clyde deletes the bookmark for {word}") do |patient_name|
  delete_bookmark(user: @clyde, patient_name: patient_name)
end

# THEN

Then("Clyde has the following patient bookmarks:") do |table|
  table.hashes.each do |row|
    expect_user_to_have_patient_in_bookmarks(user: @clyde,
                                             patient_name: row[:patient],
                                             notes: row[:notes],
                                             urgent: row[:urgent])
  end
end
