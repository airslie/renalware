describe Renalware::Patients::Merges::Operation do
  subject(:merge_operation) { build(:patient_merge_operation) }

  it "has a valid factory" do
    expect(merge_operation).to be_valid
    merge_operation.save!
  end

  it :aggregate_failures do
    is_expected.to validate_presence_of(:schema_name)
    is_expected.to validate_presence_of(:table_name)
    is_expected.to validate_presence_of(:merge)
  end

  describe "uniqueness validation with existing record" do
    subject { build(:patient_merge_operation) }

    it do
      is_expected.to validate_uniqueness_of(:table_name).scoped_to([:schema_name, :merge_id])
    end
  end
end
