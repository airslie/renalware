RSpec.describe Relay::GPConnect do
  it "has a version" do
    expect(described_class::VERSION).to match(/\A\d+\.\d+\.\d+\z/)
  end

  it "runs without Rails, ActiveRecord or Renalware loaded" do
    %i(Rails ActiveRecord Renalware).each do |name|
      expect(Object.const_defined?(name)).to be(false), "#{name} should not be loaded"
    end
  end
end
