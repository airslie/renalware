Given(/^Patty has a letter$/) do
  set_up_simple_letter_for(@patty, user: @nathalie)
end

Given(/^Patty accepted to be CCd on all letters$/) do
  @patty.update_attribute(:cc_on_all_letters, true)
end

Given(/^Patty is the main recipient on a pending letter$/) do
  @letter = set_up_simple_letter_for(@patty, user: @nathalie)
end


When(/^Nathalie drafts a letter for Patty to "(.*?)" with "(.*?)"$/) do |rec, ccs|
  recipient = letter_recipients_map.fetch(rec)
  cc_recipients = ccs.split(",").map { |cc| letter_recipients_map.fetch(cc.strip) }

  create_simple_letter(patient: @patty, user: @nathalie, issued_on: Time.zone.today,
    recipient: recipient, ccs: cc_recipients
  )
end

When(/^Nathalie submits an erroneous letter$/) do
  create_simple_letter(patient: @patty, user: @nathalie, issued_on: nil,
    recipient: @patty
  )
end

When(/^Nathalie updates Patty's address$/) do
  update_patient_address(patient: @patty, current_address_attributes: { street_1: "new street 1" })
end

When(/^Nathalie marks the letter typed$/) do
  @letter = set_up_simple_letter_for(@patty, user: @nathalie)
  @letter.typed!
end

Then(/^"(.*?)" will receive the letter$/) do |recipient|
  expect_simple_letter_to_exist(@patty, recipient: letter_recipients_map.fetch(recipient))
end

Then(/^Nathalie can update Patty's letter$/) do
  update_simple_letter(patient: @patty, user: @nathalie)
end

Then(/^the letter is not accepted$/) do
  expect_simple_letter_to_be_refused
end

Then(/^all "(.*?)" will also receive the letter$/) do |ccs|
  cc_recipients = ccs.split(",").map do |cc|
    letter_recipients_map.fetch(cc.strip)
  end
  expect_simple_letter_to_have_ccs(@patty, ccs: cc_recipients)
end

Then(/^Patty's pending letter is addressed to her new address$/) do
  expect_letter_to_be_addressed_to(
    letter: @letter.reload,
    address_attributes: { street_1: "new street 1" }
  )
end

Then(/^Doug can review the letter$/) do
  Renalware::Letters.cast_doctor(@doug).reviewable_letters.include?(@letter)
end
