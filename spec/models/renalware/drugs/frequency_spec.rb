# frozen_string_literal: true

module Renalware::Drugs
  describe Frequency do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:name)
      is_expected.to validate_presence_of(:title)
      is_expected.to have_db_index(:position)
    end

    describe ".title_for_name" do
      let(:frequency) { create(:drug_frequency, title: "Test", name: "test") }

      context "when Frequency row is present" do
        before do
          frequency
        end

        it "returns title" do
          expect(described_class.title_for_name("test")).to eq "Test"
        end
      end

      context "when Frequency row is not present" do
        it "returns the name passed" do
          expect(described_class.title_for_name("test 123")).to eq "test 123"
        end
      end
    end
  end
end
