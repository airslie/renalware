module HL7Helpers
  def hl7_message_from_file(filename, data)
    result = parse_hl7_file(filename, data)
    Renalware::Feeds::HL7Message.new(::HL7::Message.new(result.lines))
  end

  def parse_hl7_file(filename, data, pid = nil)
    patient = data # binding tweak so we can use the var patient (legacy hl7 fixtures) or patient
    body = file_fixture("hl7/#{filename}.hl7.erb").read
    ERB.new(body).result(binding)
  end

  def hl7_message_from_raw_string(raw)
    Renalware::Feeds::HL7Message.new(::HL7::Message.new(raw.lines))
  end
end
