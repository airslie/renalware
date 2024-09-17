# frozen_string_literal: true

module Renalware
  describe Pathology::CodeGroup do
    it_behaves_like "an Accountable model"
    it :aggregate_failures do
      is_expected.to be_versioned
      is_expected.to validate_presence_of(:name)
      is_expected.to validate_presence_of(:description)
      is_expected.to have_many(:memberships)
      is_expected.to have_many(:observation_descriptions).through(:memberships)
    end

    describe "uniqueness" do
      subject { described_class.new(name: "A", created_by: user, updated_by: user) }

      let(:user) { create(:user) }

      it { is_expected.to validate_uniqueness_of(:name) }
    end

    describe "#descriptions_for_group" do
      context "when supplied group name does not exist" do
        it "returns an empty array" do
          expect(described_class.descriptions_for_group("xyx")).to eq []
        end
      end
    end
  end
end
