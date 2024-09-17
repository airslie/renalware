# frozen_string_literal: true

module Renalware
  module Letters
    describe ElectronicReceipt do
      it :aggregate_failures do
        is_expected.to belong_to(:letter).touch(true)
        is_expected.to have_db_index(:recipient_id)
        is_expected.to have_db_index(:letter_id)
        is_expected.to validate_presence_of(:letter)
        is_expected.to validate_presence_of(:recipient_id)
      end

      describe "#read?" do
        context "when the receipt has not yet been read" do
          subject { described_class.new }

          it { is_expected.not_to be_read }
        end

        context "when the receipt has been read" do
          subject { described_class.new(read_at: Time.zone.now) }

          it { is_expected.to be_read }
        end
      end
    end
  end
end
