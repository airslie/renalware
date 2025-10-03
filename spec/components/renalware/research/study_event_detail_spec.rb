# frozen_string_literal: true

module Renalware
  RSpec.describe Research::StudyEventDetail do
    subject { described_class.new(record) }

    let(:subtype) { create(:event_subtype, definition:) }
    let(:record) { build(:research_study_event, subtype:) }
    let(:definition) do
      [
        { date1: { label: "Date recorded" } },
        { text5: { label: "Other comments" } }
      ]
    end

    it "renders component" do
      expect(fragment.text).to include("Date recordedNot specified")
      expect(fragment.text).to include("Other commentsNot specified")
      expect(fragment.text).to include("NotesSome notes")
    end
  end
end
