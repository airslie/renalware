module Renalware
  RSpec.describe RemoteMonitoring::ReferralReason do
    it_behaves_like "a Paranoid model"

    it { is_expected.to validate_presence_of(:description) }

    describe "uniqueness" do
      subject { described_class.build(description: "abc") }

      it { is_expected.to validate_uniqueness_of(:description) }

      it "allows duplicate description if the other is deleted" do
        described_class.create!(description: "abc", deleted_at: Time.zone.now)

        expect {
          described_class.create!(description: "abc")
        }.not_to raise_error
      end

      describe "ordered scope" do
        it "returns rows ordered by position asc then desc asc" do
          described_class.create!(description: "Y", position: 2)
          described_class.create!(description: "B", position: 2)
          described_class.create!(description: "X", position: 1)
          described_class.create!(description: "A", position: 1)

          expect(described_class.ordered.pluck(:description)).to eq(%w(A X B Y))
        end
      end
    end
  end
end
