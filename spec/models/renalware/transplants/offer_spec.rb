# frozen_string_literal: true

describe Renalware::Transplants::Offer do
  describe "#document" do
    subject { described_class.new.document }

    it { is_expected.to validate_presence_of(:donor_id) }

    it "allows donor_dob to be blank" do
      document = described_class.new.document
      document.donor_id = "NHSBT-12345"
      document.donor_dob = nil

      expect(document).to be_valid
    end

    it "does not allow donor_dob to be in the future" do
      document = described_class.new.document
      document.donor_id = "NHSBT-12345"
      document.donor_dob = 1.day.from_now.to_date

      expect(document).not_to be_valid
      expect(document.errors[:donor_dob]).to include("must be on or before #{Date.current}")
    end
  end
end
