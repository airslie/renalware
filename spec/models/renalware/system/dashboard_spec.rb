# frozen_string_literal: true

module Renalware
  describe System::Dashboard do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:components).through(:dashboard_components) }

    describe "uniqueness" do
      describe "#name" do
        subject { described_class.new(name: "X") }

        it { is_expected.to validate_uniqueness_of(:name) }
      end
    end

    describe "#name" do
      context "when user is nil" do
        it { is_expected.to validate_presence_of(:name) }
      end

      context "when user is present" do
        subject { described_class.new(user_id: 123) }

        it { is_expected.not_to validate_presence_of(:name) }
      end
    end
  end
end
