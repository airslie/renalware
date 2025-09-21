describe Renalware::Patients::Merges::Merge do
  subject(:merge) { build(:patient_merge) }

  it "has a valid factory" do
    expect(merge).to be_valid
    merge.save!
  end

  it :aggregate_failures do
    is_expected.to validate_presence_of(:major_patient)
    is_expected.to validate_presence_of(:minor_patient)
    is_expected.to validate_presence_of(:message_type)
    is_expected.to validate_presence_of(:status)
  end

  describe "validations" do
    it "is invalid if the major and minor patients are the same" do
      merge.minor_patient = merge.major_patient
      expect(merge).not_to be_valid
      expect(merge.errors[:minor_patient_id])
        .to include("must be different from major patient")
    end
  end

  describe "status enum default" do
    it "is in_progress" do
      expect(merge.status).to eq("in_progress")
    end
  end
end
