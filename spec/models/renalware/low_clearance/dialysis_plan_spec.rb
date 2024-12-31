describe Renalware::LowClearance::DialysisPlan do
  it_behaves_like "a Paranoid model"

  it :aggregate_failures do
    is_expected.to validate_presence_of(:code)
    is_expected.to validate_presence_of(:name)
  end
end
