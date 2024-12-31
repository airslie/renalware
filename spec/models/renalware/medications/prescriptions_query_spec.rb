module Renalware::Medications
  describe PrescriptionsQuery do
    let(:patient) { create(:patient) }

    context "with no filter" do
      subject(:query) { described_class.new(relation: patient.prescriptions) }

      let!(:current_prescription) do
        create(:prescription, notes: ":current:", patient: patient, treatable: patient)
      end

      it "returns prescriptions for a treatable target" do
        prescriptions = query.call

        expect(prescriptions.map(&:notes)).to include(current_prescription.notes)
      end
    end

    context "with a filter for a drug type" do
      subject(:query) do
        described_class.new(
          relation: patient.prescriptions,
          search_params: { drug_drug_types_id_eq: target_drug_type.id }
        )
      end

      let(:target_drug_type) { create(:drug_type) }
      let(:target_drug) { create(:drug, drug_types: [target_drug_type]) }
      let!(:target_prescription) do
        create(
          :prescription,
          notes: ":target:",
          patient: patient,
          treatable: patient,
          drug: target_drug
        )
      end

      let(:other_drug_type) { create(:drug_type, code: "other", name: "Other") }
      let(:other_drug) { create(:drug, drug_types: [other_drug_type]) }
      let!(:other_prescription) do
        create(
          :prescription,
          notes: ":other:",
          patient: patient,
          treatable: patient,
          drug: other_drug
        )
      end

      it "returns the current prescriptions matching the specified drug type only" do
        prescriptions = query.call

        expect(prescriptions.map(&:notes)).to include(target_prescription.notes)
        expect(prescriptions.map(&:notes)).not_to include(other_prescription.notes)
      end
    end
  end
end
