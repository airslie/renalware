module Renalware
  describe Admissions::ConsultSummaryPart do
    subject(:summary_part) { described_class.new(patient, user) }

    let(:patient) { Patient.new }
    let(:user) { User.new }

    it :aggregate_failures do
      is_expected.to respond_to(:consults)
      is_expected.to respond_to(:consults_count)
      is_expected.to respond_to(:to_partial_path)
      is_expected.to respond_to(:cache_key)
    end
  end
end
