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
    is_expected.to belong_to(:major_patient).class_name("Renalware::Patient").touch(true)
    is_expected.to belong_to(:minor_patient).class_name("Renalware::Patient").touch(true)
    is_expected.to have_many(:operations)
      .class_name("Renalware::Patients::Merges::Operation")
      .dependent(:destroy)
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

  describe "#failed!" do
    let(:error) { StandardError.new("Something went wrong") }

    it "sets the status to failed and records the failure message" do
      expect {
        merge.failed!(error)
      }.to change(merge, :status).from("in_progress").to("failed")
        .and change(merge, :failure_message).from(nil).to(include("Something went wrong"))
        .and change(merge, :updated_at)
    end
  end

  describe "#completed!" do
    it "sets the status to completed" do
      expect {
        merge.completed!
      }.to change(merge, :status).from("in_progress").to("completed")
        .and change(merge, :updated_at)
    end
  end
end
