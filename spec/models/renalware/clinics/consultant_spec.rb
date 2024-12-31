RSpec.describe Renalware::Clinics::Consultant do
  it_behaves_like "an Accountable model"
  it_behaves_like "a Paranoid model"
  it { is_expected.to validate_presence_of :name }
end
