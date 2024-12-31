Given(/^the following HL7 message:$/) do |raw_message|
  @message = parse_message(raw_message)
end

When("the message is processed") do
  process_message(@message.to_s)
end

When("the HL7 message is recorded") do
  expect_message_to_be_recorded(@message)
end
