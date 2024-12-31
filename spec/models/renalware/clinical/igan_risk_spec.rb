describe Renalware::Clinical::IganRisk do
  it_behaves_like "an Accountable model"
  it { is_expected.to be_versioned }
  it { is_expected.to have_db_index(:patient_id) }
  it { is_expected.to belong_to(:patient) }
  it { is_expected.to validate_presence_of(:patient) }
  it { is_expected.to validate_presence_of(:risk) }

  it {
    is_expected.to validate_numericality_of(:risk)
      .is_in(0.00..100.00)
      .allow_nil
  }
end
