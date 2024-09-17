# frozen_string_literal: true

module Renalware
  describe Medications::SummaryPart do
    subject(:summary_part) { described_class.new(patient, user) }

    let(:patient) { Patient.new }
    let(:user) { User.new }

    it :aggregate_failures do
      is_expected.to respond_to(:current_prescriptions)
      is_expected.to respond_to(:to_partial_path)
      is_expected.to respond_to(:cache_key)
    end

    describe ".cache_key" do
      let(:patient) { create(:patient, by: user) }
      let(:user) { create(:user) }
      let(:drug_type) { create(:drug_type, :immunosuppressant) }
      let(:drug) do
        create(:drug, name: "DrugA") do |drug|
          drug.drug_types << drug_type
        end
      end
      let(:prescription) { create(:prescription, drug: drug, patient: patient, by: user) }

      context "when a prescription associated with the patient is altered" do
        it "changes" do
          prescription
          expect {
            prescription.update_by(user, dose_amount: "xxx")
            patient.reload
          }.to change(summary_part, :cache_key)
        end
      end

      context "when a prescription's drug is altered" do
        it "changes" do
          prescription
          expect {
            prescription.drug.update(name: "DrugA1")
            patient.reload
          }.to change(summary_part, :cache_key)
        end
      end

      context "when a prescription's drug type changes" do
        it "changes" do
          prescription
          new_drug_type = create(:drug_type, :esa)
          expect {
            prescription.drug.update(drug_types: [new_drug_type])
            patient.reload
          }.to change(summary_part, :cache_key)
        end
      end

      context "when all a prescription's drug types are removed" do
        it "changes" do
          prescription
          expect {
            prescription.drug.update(drug_types: [])
            patient.reload
          }.to change(summary_part, :cache_key)
        end
      end
    end
  end
end
