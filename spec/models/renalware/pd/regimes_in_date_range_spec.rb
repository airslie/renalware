# frozen_string_literal: true

module Renalware
  module PD
    describe RegimesInDateRangeQuery do
      subject(:regimes) { described_class.new(patient: patient, from: from, to: to).call }

      let(:patient) { create(:pd_patient) }
      let(:from) { 1.year.ago }
      let(:to) { Time.zone.now }

      def create_regime(start_date:, end_date: nil)
        regime = build(:apd_regime,
                       add_hd: false,
                       patient: patient,
                       start_date: start_date,
                       end_date: end_date)
        regime.bags << build(:pd_regime_bag, :everyday)
        regime.save!
        regime
      end

      context "when a PD patient has no regimes" do
        it { is_expected.to be_empty }
      end

      context "when a PD patient has regimes inside and outside of the date range" do
        let(:from) { 1.year.ago }
        let(:to) { Time.zone.now }

        it "returns only the regime inside the date range" do
          # Not quite sure this is right - should we select the regime as its end date falls in the
          # range?
          create_regime(start_date: 2.years.ago, end_date: 1.week.ago)
          regime = create_regime(start_date: 1.week.ago, end_date: nil)

          expect(regimes).to eq [regime]
        end

        it { is_expected.to be_empty }
      end
    end
  end
end
