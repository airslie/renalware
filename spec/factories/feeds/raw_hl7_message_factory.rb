FactoryBot.define do
  factory :raw_hl7_message, class: "Renalware::Feeds::RawHL7Message" do
    body { "RAW HL7 Message" }
  end
end
