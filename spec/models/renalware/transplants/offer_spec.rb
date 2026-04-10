# frozen_string_literal: true

describe Renalware::Transplants::Offer do
  describe "#document" do
    subject { described_class.new.document }

    it { is_expected.to validate_presence_of(:donor_id) }
  end
end
