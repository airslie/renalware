shared_examples_for "an Accountable model" do
  it { is_expected.to respond_to(:by=) }
  it { is_expected.to respond_to(:save_by!) }
  it { is_expected.to have_db_index(:created_by_id) }
  it { is_expected.to have_db_index(:updated_by_id) }
end
