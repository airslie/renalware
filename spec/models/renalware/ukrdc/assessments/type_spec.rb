describe Renalware::UKRDC::Assessments::Type do
  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to have_many(:outcomes) }
end
