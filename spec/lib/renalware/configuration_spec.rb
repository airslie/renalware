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
end
