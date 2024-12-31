module Renalware
  describe Feeds::PatientLocator::StrategyClassFactory do
    # rubocop:disable Layout/LineLength
    it "can resolve all strategy classes" do
      {
        simple: Feeds::PatientLocatorStrategies::Simple,
        dob_and_any_nhs_or_assigning_auth_number: Feeds::PatientLocatorStrategies::DobAndAnyNHSOrAssigningAuthNumber,
        nhs_or_any_assigning_auth_number: Feeds::PatientLocatorStrategies::NHSOrAnyAssigningAuthNumber
      }.each do |name, klass|
        allow(Renalware.config.hl7_patient_locator_strategy)
          .to receive(:fetch)
          .with(:oru)
          .and_return(name)

        expect(described_class.new(:oru).call).to eq(klass)
      end
    end
    # rubocop:enable Layout/LineLength

    it "raises an error if the configured strategy does not translate to a class" do
      allow(Renalware.config.hl7_patient_locator_strategy)
        .to receive(:fetch)
        .with(:oru)
        .and_return(:missing)

      expect {
        described_class.new(:oru).call
      }.to raise_error(Renalware::Feeds::PatientLocator::StrategyClassFactory::InvalidStrategyError)
    end

    it "raises an error if the configured strategy does" do
      allow(Renalware.config.hl7_patient_locator_strategy)
        .to receive(:fetch)
        .with(:oru)
        .and_raise(KeyError)

      expect {
        described_class.new(:oru).call
      }.to raise_error(Renalware::Feeds::PatientLocator::StrategyClassFactory::MissingStrategyError)
    end
  end

  describe Feeds::PatientLocator do
    describe "#call" do
      it "delegates to the configured strategy" do
        allow(Renalware.config.hl7_patient_locator_strategy)
          .to receive(:fetch)
          .with(:oru)
          .and_return(:simple)

        allow(Feeds::PatientLocatorStrategies::Simple).to receive(:call).and_return("test")

        expect(described_class.call(:oru)).to eq("test")
      end
    end
  end
end
