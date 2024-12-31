module Renalware
  module HD
    describe GenerateMonthlyStatisticsAndRefreshMaterializedViewJob do
      let(:monthly_statistics) { instance_double(GenerateMonthlyStatistics, call: nil) }

      before do
        allow(GenerateMonthlyStatistics)
          .to receive(:new).with(month: nil, year: nil)
          .and_return monthly_statistics
        allow(RefreshMaterializedViewJob)
          .to receive(:perform_later)
      end

      describe "#perform" do
        it "delegates to a service object passing in last month" do
          described_class.perform_now

          expect(monthly_statistics).to have_received(:call)
          expect(RefreshMaterializedViewJob).to have_received(:perform_later)
        end
      end
    end
  end
end
