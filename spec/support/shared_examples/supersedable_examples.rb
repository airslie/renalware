shared_examples_for "a Supersedable model" do
  it { is_expected.to have_db_column(:deactivated_at) }
  it { is_expected.to have_db_column(:active) }
  it { is_expected.to have_db_index(:deactivated_at) }

  it "adds a deactivated_at where clause" do
    expect(described_class.all.to_sql).to include(".\"deactivated_at\" IS NULL")
  end

  it "skips adding the deactivated_at where clause when unscoped" do
    expect(described_class.unscoped.to_sql.to_s).not_to include("\"deactivated_at\"")
  end
end
