# frozen_string_literal: true

module Renalware
  RSpec.describe Research::Investigatorship do
    it_behaves_like "an Accountable model"
    it { is_expected.to be_versioned }

    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :study }

    it { is_expected.to validate_presence_of :user }
    it { is_expected.to validate_presence_of :study }

    describe "#to_s" do
      it "delegates to user" do
        user = build_stubbed(:user)
        investigator = described_class.new(user: user)

        expect(investigator.to_s).to eq(user.to_s)
      end
    end
  end
end
