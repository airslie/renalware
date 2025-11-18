# From https://github.com/rubysherpas/paranoia/wiki/Testing-with-rspec
shared_examples_for "a Paranoid model" do
  let(:paranoia_column) do
    if described_class.respond_to?(:paranoia_column)
      described_class.paranoia_column.to_sym
    else
      :deleted_at
    end
  end

  let(:quoted_paranoia_column) do
    described_class.connection.quote_column_name(paranoia_column)
  end

  it { is_expected.to have_db_column(paranoia_column) }
  it { is_expected.to have_db_index(paranoia_column) }

  it "adds a deleted_at where clause" do
    expect(described_class.all.to_sql).to include %(#{quoted_paranoia_column} IS NULL)
  end

  it "skips adding the deleted_at where clause when unscoped" do
    expect(described_class.unscoped.to_sql).not_to include %(#{quoted_paranoia_column} IS NULL)
  end
end
