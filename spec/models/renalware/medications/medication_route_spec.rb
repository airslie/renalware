# frozen_string_literal: true

module Renalware
  module Medications
    describe MedicationRoute do
      subject(:route) { described_class.new }

      it :aggregate_failures do
        is_expected.to validate_presence_of :code
        is_expected.to validate_presence_of :name
        is_expected.to have_db_index(:code).unique(true)
      end

      describe "#other?" do
        it "case-insensitively matches the code 'other'" do
          expect(described_class.new(name: "other").other?).to be(true)
          expect(described_class.new(name: "OTHER").other?).to be(true)
        end
      end

      describe "#ordered scope" do
        it do
          xx = create(:medication_route, :po, weighting: 50, code: :xx)
          po = create(:medication_route, :po, weighting: 100)
          other = create(:medication_route, :other, weighting: 0)

          expect(described_class.ordered.to_a).to eq([po, xx, other])
        end
      end
    end
  end
end
