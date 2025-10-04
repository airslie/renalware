# frozen_string_literal: true

module Renalware
  RSpec.describe Clinical::DukeActivityStatusIndexDetail do
    subject { described_class.new(record) }

    let(:record) { build(:duke_activity_status_index) }

    it "renders component" do
      expect(fragment.text).to include("Score:1.0")
      expect(fragment.text).to include("Notes:Not specified")
    end

    context "when notes are included" do
      let(:record) { build(:duke_activity_status_index, notes: "Some notes") }

      it "renders component" do
        expect(fragment.text).to include("Notes:Some notes")
      end
    end
  end
end
