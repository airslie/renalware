# frozen_string_literal: true

module Renalware
  RSpec.describe Admissions::ConsultTimelineRow do
    subject { described_class.new(sort_date:, record:) }

    let(:sort_date) { Date.new(2025, 7, 9) }
    let(:record) { build(:admissions_consult, aki_risk: "yes") }
    let(:created_by) { record.created_by.full_name }

    it "renders component with correct type and description" do
      expect(table_fragment.css(".toggler i")).not_to be_empty
      expect(table_fragment.text).to include "09-Jul-2025"
      expect(table_fragment.text).to include "Consult"
      expect(table_fragment.text).to include "AKI Risk: Yes"
      expect(table_fragment.text).to include created_by
    end

    context "when aki_risk is 'no'" do
      let(:record) { build(:admissions_consult, aki_risk: "no") }

      it "displays 'AKI Risk: No'" do
        expect(table_fragment.text).to include "AKI Risk: No"
      end
    end

    context "when aki_risk is 'unknown'" do
      let(:record) { build(:admissions_consult, aki_risk: "unknown") }

      it "displays 'AKI Risk: Unknown'" do
        expect(table_fragment.text).to include "AKI Risk: Unknown"
      end
    end

    context "when aki_risk is nil" do
      let(:record) { build(:admissions_consult, aki_risk: nil) }

      it "handles nil aki_risk gracefully" do
        expect { table_fragment }.not_to raise_error
        expect(table_fragment.text).to include "AKI Risk:"
      end
    end

    context "with hospital ward" do
      let(:hospital_ward) { build(:hospital_ward, name: "ICU Ward") }
      let(:record) { build(:admissions_consult, hospital_ward:) }

      it "displays detail component in detail section" do
        hidden_section = table_fragment.css(".hidden")
        expect(hidden_section.text).to include "Author"
        expect(hidden_section.text).to include "Description"
        expect(hidden_section.text).to include "Modality"
        expect(hidden_section.text).to include "E-Alert"
      end
    end
  end
end
