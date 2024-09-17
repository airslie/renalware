# frozen_string_literal: true

module Renalware
  module Patients
    describe LastSuccessfulPracticeSyncDateQuery do
      describe "#call" do
        subject(:date) { described_class.new(identifier).call }

        let(:identifier) { "nhs_data_api" }

        context "when there are no APILog rows with a matching identifier" do
          it "returns nil" do
            create(:api_log, :done, identifier: "other identifer", created_at: "2019-01-01")

            expect(date).to be_nil
          end
        end

        context "when there are DONE APILog rows matching the identifer" do
          it "returns the latest created_at date of that row" do
            create(:api_log, :done, identifier: identifier, created_at: "2019-01-01")
            create(:api_log, :done, identifier: identifier, created_at: "2019-02-01")
            create(:api_log, :error, identifier: identifier, created_at: "2019-03-01")
            create(:api_log, :working, identifier: identifier, created_at: "2019-04-01")

            expect(date).to eq("2019-02-01")
          end
        end
      end
    end
  end
end
