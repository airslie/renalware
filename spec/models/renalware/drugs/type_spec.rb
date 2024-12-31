module Renalware::Drugs
  describe Type do
    it :aggregate_failures do
      is_expected.to have_many(:drug_type_classifications)
      is_expected.to have_many(:drugs).through(:drug_type_classifications)
      is_expected.to be_versioned
    end

    describe "#active_drugs" do
      subject { described_class.new.active_drugs }
      it { is_expected.to eq [] }
    end
  end
end
