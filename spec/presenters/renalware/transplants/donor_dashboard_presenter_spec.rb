# frozen_string_literal: true

describe Renalware::Transplants::DonorDashboardPresenter do
  subject { described_class.new(instance_double(Renalware::Patient)) }

  it :aggregate_failures do
    is_expected.to respond_to :patient
    is_expected.to respond_to :donations
    is_expected.to respond_to :donor_workup
    is_expected.to respond_to :donor_operations
    is_expected.to respond_to :donor_stages
  end
end
