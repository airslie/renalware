describe Renalware::Configuration do
  subject(:config) { Renalware.config }

  it "raises an error if a certain config value is not defined" do
    expect { config.missing_value }.to raise_error(NoMethodError)
  end

  describe "#delay_after_which_a_finished_session_becomes_immutable" do
    it "defaults to 6 hours" do
      expect(config.delay_after_which_a_finished_session_becomes_immutable).to eq(6.hours)
    end
  end

  describe "#devise_extra_modules" do
    it "defaults to empty" do
      expect(config.devise_extra_modules).to eq([])
    end

    it "can be set via ENV" do
      pending "This doesn't work due to Renalware.config loading before tests"
      # Recommend fixing by making config accessors lazy load but possibly also
      # use Rails configuration.
      ENV["DEVISE_EXTRA_MODULES"] = "module1,module2"
      expect(config.devise_extra_modules).to eq([:module1, :module2])
    end
  end
end
