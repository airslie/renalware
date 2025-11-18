describe Renalware::Patients::Merges::Log do
  subject(:merge_log) {
    build(
      :patient_merge_log,
      operation: merge_operation,
      id_of_updated_record: 1
    )
  }

  let(:merge_operation) { create(:patient_merge_operation) }

  it "has a valid factory" do
    expect(merge_log).to be_valid
    merge_log.save!
  end

  it :aggregate_failures do
    is_expected.to validate_presence_of(:operation)
    is_expected.to validate_presence_of(:id_of_updated_record)
    is_expected.to belong_to(:operation)
  end

  # describe "uniqueness validation with existing record" do
  #   subject { build(:patient_merge_operation) }

  #   it do
  #     is_expected.to validate_uniqueness_of(:table_name).scoped_to([:schema_name, :merge_id])
  #   end
  # end

  # describe "column_reference" do
  #   it "uses a composed_of ColumnReference value object" do
  #     expect(merge_operation.column_reference).to have_attributes(
  #       schema: "S", table: "T", column: "C"
  #     )
  #   end
  # end
end
