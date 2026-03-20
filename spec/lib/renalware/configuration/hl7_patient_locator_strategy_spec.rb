describe Renalware::Configuration::HL7PatientLocatorStrategy do
  subject(:strategy) { described_class.load_from_env }

  around do |example|
    original_value = ENV.fetch("HL7_PATIENT_LOCATOR_STRATEGY", nil)
    ENV.delete("HL7_PATIENT_LOCATOR_STRATEGY")

    example.run
  ensure
    if original_value.nil?
      ENV.delete("HL7_PATIENT_LOCATOR_STRATEGY")
    else
      ENV["HL7_PATIENT_LOCATOR_STRATEGY"] = original_value
    end
  end

  it "uses defaults when ENV is not present" do
    expect(strategy).to eq(
      oru: :simple,
      adt: :simple
    )
  end

  it "parses a JSON value from ENV" do
    ENV["HL7_PATIENT_LOCATOR_STRATEGY"] =
      { "oru" => "dob_and_any_nhs_or_assigning_auth_number", "adt" => "dynamic" }.to_json

    expect(strategy).to eq(
      oru: :dob_and_any_nhs_or_assigning_auth_number,
      adt: :dynamic
    )
  end

  it "parses a double-encoded JSON value from ENV" do
    ENV["HL7_PATIENT_LOCATOR_STRATEGY"] =
      "{\"oru\":\"dob_and_any_nhs_or_assigning_auth_number\",\"adt\":\"dynamic\"}".to_json

    expect(strategy).to eq(
      oru: :dob_and_any_nhs_or_assigning_auth_number,
      adt: :dynamic
    )
  end

  it "raises if a required key is missing" do
    ENV["HL7_PATIENT_LOCATOR_STRATEGY"] = { "oru" => "simple" }.to_json

    expect {
      strategy
    }.to raise_error(ArgumentError, /missing keys: adt/)
  end

  it "raises if a strategy value is invalid" do
    ENV["HL7_PATIENT_LOCATOR_STRATEGY"] =
      { "oru" => "simple", "adt" => "not_a_strategy" }.to_json

    expect {
      strategy
    }.to raise_error(ArgumentError, /invalid values: adt=not_a_strategy/)
  end
end
