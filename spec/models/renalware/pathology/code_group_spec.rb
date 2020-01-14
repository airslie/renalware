# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe Pathology::CodeGroup, type: :model do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:name)
      is_expected.to have_many(:memberships)
      is_expected.to have_many(:observation_descriptions).through(:memberships)
    end

    describe "uniqueness" do
      subject { described_class.new(name: "A") }

      it { is_expected.to validate_uniqueness_of(:name) }
    end
  end
end
