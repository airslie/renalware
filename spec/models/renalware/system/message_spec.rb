module Renalware
  describe System::Message do
    it { is_expected.to validate_presence_of(:body) }

    describe ".active scope" do
      subject(:scope) { described_class.active }

      it do
        active_message = create(
          :system_message,
          display_from: 1.day.ago,
          display_until: 1.day.from_now
        )
        # past
        create(:system_message, display_from: 1.day.ago, display_until: 10.minutes.ago)
        # future
        create(:system_message, display_from: 10.minutes.from_now, display_until: 1.day.from_now)

        expect(scope).to eq [active_message]
      end
    end

    describe "#active?" do
      subject {
        described_class.new(display_from: display_from, display_until: display_until).active?
      }

      let(:display_from) { nil }
      let(:display_until) { nil }

      context "when display_from is in the future" do
        let(:display_from) { 1.day.from_now }

        it { is_expected.to be(false) }
      end

      context "when display_from is in the past and there is no display_until set" do
        let(:display_from) { 1.day.ago }
        let(:display_until) { nil }

        it { is_expected.to be(true) }
      end

      context "when display_from and display_until are in the past" do
        let(:display_from) { 2.days.ago }
        let(:display_until) { 1.day.ago }

        it { is_expected.to be(false) }
      end

      context "when display_from is in the past and display_until is in the future" do
        let(:display_from) { 1.day.ago }
        let(:display_until) { 1.day.from_now }

        it { is_expected.to be(true) }
      end
    end
  end
end
