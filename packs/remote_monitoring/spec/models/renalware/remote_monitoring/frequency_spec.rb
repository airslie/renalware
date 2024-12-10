# frozen_string_literal: true

module Renalware
  RSpec.describe RemoteMonitoring::Frequency do
    it_behaves_like "a Paranoid model"

    it { is_expected.to validate_presence_of(:period) }
    it { is_expected.to validate_presence_of(:position) }

    it "stores period as a duration which can be displayed as a string using #inspect" do
      freq = described_class.create!(period: 1.month)

      expect(described_class.all).to eq([freq])
      expect(freq.period.inspect).to eq("1 month")
    end

    describe "uniqueness" do
      subject { described_class.build(period: 1.month) }

      it { is_expected.to validate_uniqueness_of(:period) }

      it "allows duplicate period if the other is deleted" do
        described_class.create!(period: 1.month, deleted_at: Time.zone.now)

        expect {
          described_class.create!(period: 1.month)
        }.not_to raise_error
      end
    end

    describe "ordered scope" do
      it "returns rows ordered by position asc" do
        (1..5).to_a.shuffle.each do |idx|
          described_class.create!(period: idx.month, position: idx)
        end

        expect(described_class.ordered.pluck(:position)).to eq([1, 2, 3, 4, 5])
      end
    end
  end
end
