describe Renalware::Clinical::Patient do
  it { is_expected.to have_many :allergies }
  it { is_expected.to have_one(:igan_risk) }

  describe "#allergy_status default value" do
    subject(:allergy_status) { described_class.new.allergy_status }

    it { is_expected.to be_unrecorded }
  end

  describe "#latest_dry_weight" do
    it "returns the latest dry weight" do
      patient = create(:clinical_patient)
      create(:dry_weight, patient: patient, weight: 123, assessed_on: 1.year.ago)
      newer = create(:dry_weight, patient: patient, weight: 234, assessed_on: 1.day.ago)

      expect(patient.latest_dry_weight).to eq(newer)
    end

    it "returns nil when the patient has no dry weight measurements" do
      patient = create(:clinical_patient)

      expect(patient.latest_dry_weight).to be_nil
    end
  end
end
