describe Renalware::Admissions::Request do
  it_behaves_like "a Paranoid model"
  it_behaves_like "an Accountable model"
  it :aggregate_failures do
    is_expected.to belong_to(:patient).touch(true)
    is_expected.to validate_presence_of :patient_id
    is_expected.to validate_presence_of :reason_id
    is_expected.to validate_presence_of :priority
    is_expected.to respond_to :position
  end
end
