# frozen_string_literal: true

require "rails_helper"

module Renalware
  module System
    describe Role do
      it { is_expected.to validate_uniqueness_of(:name) }

      describe ".fetch" do
        context "with an empty collection of id's" do
          it "returns none" do
            expect(Role.fetch([])).to be_empty
          end
        end

        context "with a collection of id's" do
          let!(:role) { create(:role, name: "fake_role") }

          it "returns the specified roles" do
            expect(Role.fetch([role.id]).map(&:name)).to include("fake_role")
          end
        end
      end
    end
  end
end
