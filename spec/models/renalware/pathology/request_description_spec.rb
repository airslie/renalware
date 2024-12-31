describe Renalware::Pathology::RequestDescription do
  subject(:request_description) { build(:pathology_request_description) }

  it :aggregate_failures do
    is_expected.to validate_presence_of(:lab)
    is_expected.to have_db_index(:code).unique(true)
  end

  describe "#to_s" do
    it { expect(request_description.to_s).to eq(request_description.code) }
  end
end
