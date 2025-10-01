# frozen_string_literal: true

module Renalware
  RSpec.describe Events::EventTimelineRow do
    subject { described_class.new(sort_date:, record:) }

    let(:sort_date) { Date.new(2025, 7, 9) }
    let(:record) { build(:simple_event) }
    let(:created_by) { record.created_by.full_name }

    it "renders component" do
      expect(table_fragment.text).to include("09-Jul-2025EventSimple Event#{created_by}")
      expect(table_fragment.css(".hidden").text).to include("Description:Needs blood sample taken.")
      expect(table_fragment.css(".hidden").text).to include(
        "Notes:Would like son to accompany them on clinic visit."
      )
    end

    context "when component is not within Events module" do
      let(:record) { build(:remote_monitoring_registration) }

      it "renders component" do
        expect(table_fragment.text).to include(
          "09-Jul-2025EventRemote Monitoring Registration#{created_by}"
        )
        expect(table_fragment.css(".hidden").text).to include("Referral reason:Not specified")
        expect(table_fragment.css(".hidden").text).to include("Monitoring frequency:4 months")
      end
    end
  end
end
