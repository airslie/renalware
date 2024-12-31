module Renalware::Drugs::DMDMigration
  describe UnitOfMeasureMigrator do
    let(:unit_of_measure) { create(:drug_unit_of_measure, name: "capsule") }
    let(:prescription) { create(:prescription, dose_unit: "capsule") }

    before do
      unit_of_measure && prescription
    end

    it "migrates the string version of the unit of measure to a foreign key one" do
      described_class.new.call
      expect(prescription.reload.unit_of_measure_id).to eq unit_of_measure.id

      # Re-run with different name -> shouldn't change anything or report an error
      unit_of_measure.update_column(:name, "test")

      described_class.new.call
      expect(prescription.reload.unit_of_measure_id).to eq unit_of_measure.id
    end
  end
end
