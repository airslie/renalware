describe Renalware::Patients::Merges::Rule do
  subject(:rule) { build(:patient_merge_rule) }

  it "has a valid factory" do
    expect(rule).to be_valid
    rule.save!
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:schema_name) }
    it { is_expected.to validate_presence_of(:table_name) }
    it { is_expected.to validate_presence_of(:merge) }
    it { is_expected.to validate_uniqueness_of(:table_name).scoped_to(:schema_name) }
  end
end
