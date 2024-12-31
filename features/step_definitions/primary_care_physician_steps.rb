Given(/^([A-Za-z]+) ([A-Za-z]+) is a primary care physician with telephone number: (\d+)$/) do |name, telephone|
  Renalware::Patients::PrimaryCarePhysician.create!(
    email: "john.merrill@nhs.net",
    name: name,
    practitioner_type: "GP",
    telephone: telephone,
    address: Renalware::Address.new(street_1: "123 Fake street"),
    code: SecureRandom.uuid
  )
end
