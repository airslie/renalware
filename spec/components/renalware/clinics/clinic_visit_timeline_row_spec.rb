# frozen_string_literal: true

module Renalware
  RSpec.describe Clinics::ClinicVisitTimelineRow do
    subject { described_class.new(sort_date:, record:) }

    let(:sort_date) { Date.new(2025, 7, 9) }
    let(:location) { build(:clinic_visit_location, :teams) }
    let(:record) do
      build(
        :clinic_visit,
        location:,
        notes: "Good progress with treatment",
        admin_notes: "Patient arrived on time"
      )
    end
    let(:created_by) { record.created_by.full_name }
    let(:clinic) { record.clinic.name }

    it "renders component" do
      expect(table_fragment.css(".toggler i")).not_to be_empty
      expect(table_fragment.text).to include("09-Jul-2025Clinic Visit#{clinic}#{created_by}")
      expect(table_fragment.css(".hidden").text).to include("Location:Over Teams")
      expect(table_fragment.css(".hidden").text).to include("Notes:Good progress with treatment")
      expect(table_fragment.css(".hidden").text).to include("Admin notes:Patient arrived on time")
    end

    context "when dietetic clinic visit" do
      let(:record) { build(:dietetic_clinic_visit) }

      it "render component" do
        expect(table_fragment.text).to include(
          "09-Jul-2025Dietetic Clinic Visit#{clinic}#{created_by}"
        )
        expect(table_fragment.css(".hidden").text).to include(
          "Adjusted BMI for amputations/significant oedema"
        )
      end
    end
  end
end
