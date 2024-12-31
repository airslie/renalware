describe Renalware::Clinics::VisitLocation do
  it_behaves_like "an Accountable model"
  it_behaves_like "a Paranoid model"

  it :aggregate_failures do
    is_expected.to be_versioned
    is_expected.to validate_presence_of :name
    is_expected.to have_db_index(:name)
  end

  describe "uniqueness" do
    subject do
      described_class.new(name: "Telephone", by: user)
    end

    let(:user) { create(:user) }

    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
