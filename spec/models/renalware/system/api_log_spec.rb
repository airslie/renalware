# frozen_string_literal: true

module Renalware
  describe System::APILog do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:identifier)
      is_expected.to validate_presence_of(:status)
    end

    describe ".with_log" do
      it "creates a new log with a working status, yields it, then updates the status to success" do
        the_log = described_class.with_log("test") do |log|
          expect(log).to be_persisted
          expect(log).to have_attributes(
            identifier: "test",
            status: described_class::STATUS_WORKING,
            elapsed_ms: nil
          )

          log.update!(
            dry_run: true,
            records_added: 99,
            records_updated: 1
          )
        end

        expect(the_log.reload).to have_attributes(
          identifier: "test",
          status: described_class::STATUS_DONE,
          dry_run: true,
          records_added: 99,
          records_updated: 1
        )
        expect(the_log.elapsed_ms).to be > 0
      end

      it "logs any exception that occurs within the block, then re-raises the exception" do
        saved_log = nil

        expect do
          described_class.with_log("test") do |log|
            saved_log = log
            1 / 0
          end
        end.to raise_error(ZeroDivisionError, "divided by 0")

        expect(saved_log.reload).to have_attributes(
          identifier: "test",
          status: described_class::STATUS_ERROR
        )
        expect(saved_log.error).to start_with("divided by 0\nBacktrace")
      end
    end
  end
end
