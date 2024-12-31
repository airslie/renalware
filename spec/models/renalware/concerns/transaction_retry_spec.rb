module Renalware
  describe TransactionRetry do # rubocop:disable RSpec/SpecFilePathFormat
    def test_class
      Class.new(ApplicationRecord) do
        include TransactionRetry
        self.table_name = "examples"

        def self.name
          "Example"
        end
      end
    end

    describe "#transaction" do
      it "retries at most once if ActiveRecord::PreparedStatementCacheExpired is raised" do
        tries = 0
        expect {
          test_class.transaction do
            tries += 1
            # The first time the txn ghets this error it will rescue and retry.
            # If the error is raised a second time in the same txn then it will just re-raise it.
            # That retrying is why tries ends up as 2 here - the block has been executerd
            raise ActiveRecord::PreparedStatementCacheExpired
          end
        }.to raise_error(ActiveRecord::PreparedStatementCacheExpired)
        expect(tries).to eq(2)
      end
    end
  end
end
