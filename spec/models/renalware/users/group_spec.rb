# frozen_string_literal: true

module Renalware
  describe Users::Group do
    it_behaves_like "an Accountable model"
    it :aggregate_failures do
      is_expected.to validate_presence_of(:name)
      is_expected.to have_db_index(:name).unique(true)
      is_expected.to have_many(:memberships)
    end

    describe "#uniqueness" do
      subject { described_class.new(name: "G1", by: create(:user)) }

      it { is_expected.to validate_uniqueness_of(:name) }
    end
  end
end
