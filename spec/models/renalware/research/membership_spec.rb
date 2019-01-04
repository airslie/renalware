# frozen_string_literal: true

require "rails_helper"

module Renalware
  RSpec.describe Research::Membership, type: :model do
    it_behaves_like "an Accountable model"

    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :study }
    it { is_expected.to belong_to :hospital_centre }

    it { is_expected.to validate_presence_of :user }
    it { is_expected.to validate_presence_of :study }
    it { is_expected.to validate_presence_of :hospital_centre }

    describe "#to_s" do
      it "delegates to user" do
        user = build_stubbed(:user)
        membership = described_class.new(user: user)

        expect(membership.to_s).to eq(user.to_s)
      end
    end
  end
end
