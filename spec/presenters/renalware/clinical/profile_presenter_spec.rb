describe Renalware::Clinical::ProfilePresenter do
  subject { described_class.new(patient: patient, params: {}) }

  let(:patient) { build(:patient) }

  it :aggregate_failures do
    is_expected.to respond_to(:allergies)
    is_expected.to respond_to(:swabs)
  end
end
