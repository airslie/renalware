RSpec.describe Renalware::Accesses::ProfileAtTimeQuery do
  describe "#call" do
    subject(:result) { described_class.new(patient:, at:).call }

    let(:patient) { create(:accesses_patient) }
    let(:at) { Date.parse("2023-06-15") }

    context "when no profile matches the at window" do
      before do
        create(:access_profile, patient:, started_on: Date.parse("2023-06-16"), terminated_on: nil)
        create(:access_profile,
               patient:,
               started_on: Date.parse("2020-01-01"),
               terminated_on: Date.parse("2022-12-31"))
      end

      it "returns nil" do
        expect(result).to be_nil
      end
    end

    context "when exactly one profile matches" do
      let!(:matching_profile) do
        create(:access_profile, patient:, started_on: Date.parse("2023-01-01"), terminated_on: nil)
      end

      before do
        create(:access_profile, patient:, started_on: Date.parse("2023-07-01"), terminated_on: nil)
        create(:access_profile,
               patient:,
               started_on: Date.parse("2022-01-01"),
               terminated_on: Date.parse("2023-01-31"))
      end

      it "returns that profile" do
        expect(result).to eq(matching_profile)
      end
    end

    context "when multiple profiles match" do
      let!(:picked_profile) do
        create(:access_profile,
               patient:,
               started_on: Date.parse("2019-01-01"),
               terminated_on: Date.parse("2025-01-01"))
      end

      before do
        create(:access_profile,
               patient:,
               started_on: Date.parse("2020-01-01"),
               terminated_on: nil)
        create(:access_profile,
               patient:,
               started_on: Date.parse("2019-01-01"),
               terminated_on: Date.parse("2024-01-01"))
        create(:access_profile,
               patient: create(:accesses_patient),
               started_on: Date.parse("2010-01-01"),
               terminated_on: nil)
      end

      it "returns only one profile according to query ordering" do
        expect(result).to eq(picked_profile)
      end
    end
  end
end
