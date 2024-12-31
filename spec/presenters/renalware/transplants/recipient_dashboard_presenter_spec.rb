describe Renalware::Transplants::RecipientDashboardPresenter do
  subject { described_class.new(instance_double(Renalware::Patient)) }

  it :aggregate_failures do
    is_expected.to respond_to :patient
    is_expected.to respond_to :recipient_workup
    is_expected.to respond_to :registration
    is_expected.to respond_to :recipient_operations
    is_expected.to respond_to :donations
    is_expected.to respond_to :investigations
  end
end
