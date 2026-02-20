describe Renalware::UKRDC::Assessments::Outcome do
  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to belong_to(:assessment_type).optional(false) }
end
