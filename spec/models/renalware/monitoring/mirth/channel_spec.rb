module Renalware::Monitoring
  describe Mirth::Channel do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:uuid) }
    it { is_expected.to belong_to(:channel_group) }
  end
end
