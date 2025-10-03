# frozen_string_literal: true

module Renalware
  RSpec.describe Messaging::Internal::MessageTimelineRow do
    subject { described_class.new(sort_date:, record:) }

    let(:sort_date) { Date.new(2025, 7, 9) }
    let(:record) { build(:internal_message) }
    let(:created_by) { record.author.full_name }

    it "renders component" do
      expect(table_fragment.text).to include "09-Jul-2025MessageThe subject#{created_by}"
      expect(table_fragment.css(".hidden").text).to eq "The body"
    end
  end
end
