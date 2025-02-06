module Renalware::Monitoring
  describe Mirth::ChannelStats do
    it { is_expected.to belong_to(:channel) }
    it { is_expected.to validate_presence_of(:channel) }
    it { is_expected.to validate_numericality_of(:sent) }
    it { is_expected.to validate_numericality_of(:received) }
    it { is_expected.to validate_numericality_of(:queued) }
    it { is_expected.to validate_numericality_of(:error) }
    it { is_expected.to validate_numericality_of(:filtered) }
  end
end
