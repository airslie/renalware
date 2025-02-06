module Renalware::Monitoring
  describe Mirth::ChannelGroup do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:uuid) }
  end
end
