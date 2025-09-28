describe Renalware::Patients::Merges::Operation do
  subject(:merge_operation) {
    build(
      :patient_merge_operation,
      schema_name: "S",
      table_name: "T",
      column_name: "C"
    )
  }

  it "has a valid factory" do
    expect(merge_operation).to be_valid
    merge_operation.save!
  end

  it :aggregate_failures do
    is_expected.to validate_presence_of(:schema_name)
    is_expected.to validate_presence_of(:table_name)
    is_expected.to validate_presence_of(:merge)
    is_expected.to belong_to(:merge)
    is_expected.to have_many(:logs)
  end

  describe "uniqueness validation with existing record" do
    subject { build(:patient_merge_operation) }

    it do
      is_expected.to validate_uniqueness_of(:column_name)
        .scoped_to([:merge_id, :schema_name, :table_name])
    end
  end

  describe "column_reference" do
    it "uses a composed_of ColumnReference value object" do
      expect(merge_operation.column_reference)
        .to have_attributes(schema: "S", table: "T", column: "C")
    end
  end
end
