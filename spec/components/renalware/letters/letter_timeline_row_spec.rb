# frozen_string_literal: true

module Renalware
  RSpec.describe Letters::LetterTimelineRow do
    subject { described_class.new(sort_date:, record:) }

    let(:sort_date) { Date.new(2025, 7, 9) }
    let(:record) { build(:draft_letter) }
    let(:description) { record.topic.text }
    let(:created_by) { record.created_by.full_name }

    it "renders component" do
      expect(table_fragment.css(".toggler i")).not_to be_empty
      expect(table_fragment.text).to include("09-Jul-2025Letter (Draft)#{description}#{created_by}")
      expect(table_fragment.css(".hidden").text).to eq(
        "I am pleased to report a marked improvement in her condition."
      )
    end
  end
end
