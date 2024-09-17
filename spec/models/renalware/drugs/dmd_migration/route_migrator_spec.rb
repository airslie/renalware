# frozen_string_literal: true

module Renalware::Drugs
  describe DMDMigration::RouteMigrator do
    let(:previous_route) {
      create(:medication_route, code: "per_oral", name: "Per Oral", rr_code: "1")
    }
    let(:prescription) { create(:prescription, medication_route: previous_route) }

    before do
      prescription && dmd_route
    end

    context "when there's a match" do
      let(:dmd_route) { create(:medication_route, code: "oral", name: "Oral", rr_code: "1") }

      it "migrates from the previous route to the new DMD ones" do
        described_class.new.call
        expect(prescription.reload.medication_route).to eq dmd_route

        # Re-run -> shouldn't change anything
        described_class.new.call
        prescription.reload
        expect(prescription.medication_route).to eq dmd_route
        expect(prescription.legacy_medication_route_id).to eq previous_route.id
      end
    end

    context "when there's no match" do
      let(:dmd_route) { create(:medication_route, code: "oral", name: "Oral No Match") }

      it "does nothing" do
        described_class.new.call
        expect(prescription.reload.medication_route).to eq previous_route
      end
    end
  end
end
