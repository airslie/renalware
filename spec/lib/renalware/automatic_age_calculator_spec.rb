# frozen_string_literal: true

module Renalware
  describe AutomaticAgeCalculator, type: :model do
    subject(:calculator) do
      described_class.new(existing_age, born_on: born_on, age_on_date: age_on_date)
    end

    let(:existing_age) { nil }
    let(:age_on_date) { Time.zone.today }

    describe "#compute" do
      context "when born_on is provided" do
        subject(:computed_age) { calculator.compute }

        let(:born_on) { 45.years.ago.to_date }

        it { is_expected.to have_attributes(amount: 45, unit: "years") }
      end

      context "when born_on is blank" do
        subject(:computed_age) { calculator.compute }

        let(:born_on) { nil }
        let(:existing_age) { Age.new_from(years: 4, months: 1, days: 0) }

        it { is_expected.to eq(existing_age) }
      end
    end
  end
end
