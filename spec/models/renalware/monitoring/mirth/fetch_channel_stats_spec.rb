module Renalware::Monitoring::Mirth
  describe FetchChannelStats do
    describe "#call" do
      def cassette(path) = File.join("monitoring/mirth/api", path)

      context "when the API is available and there are two channels" do
        it "writes Mirth stats to the database, creating channel rows JIT" do
          VCR.use_cassette(cassette("success")) do
            described_class.call
          end

          expect(Channel.count).to eq(2)
          expect(ChannelStats.count).to eq(2)

          # Make a second call
          VCR.use_cassette(cassette("success")) do
            described_class.call
          end

          expect(Channel.count).to eq(2)
          expect(ChannelStats.count).to eq(4)

          log = Renalware::System::APILog.last
          expect(log.identifier).to eq("Renalware::Monitoring::Mirth::FetchChannelStats")
          expect(log.status).to eq("done")
        end

        context "when credentials are invalid" do
          it "logs the error" do
            VCR.use_cassette(cassette("invalid_credentials")) do
              expect {
                described_class.call
              }.to raise_error(Faraday::UnauthorizedError)
            end

            log = Renalware::System::APILog.last
            expect(log.identifier).to eq("Renalware::Monitoring::Mirth::FetchChannelStats")
            expect(log.status).to eq("error")
            expect(log.error).to start_with("the server responded with status 401")
          end
        end
      end

      context "when the API is unavailable due to a network error eg Connection refused" do
        it "logs the error" do
          allow(Renalware.config)
            .to receive(:monitoring_mirth_api_base_url)
            .and_return("https://localhost:010101010101010")

          VCR.use_cassette(cassette("network_error")) do # will not actually create cassette here
            expect {
              described_class.call
            }.to raise_error(Faraday::ConnectionFailed)
          end

          expect(Channel.count).to eq(0)
          expect(ChannelStats.count).to eq(0)

          log = Renalware::System::APILog.last
          expect(log.identifier).to eq("Renalware::Monitoring::Mirth::FetchChannelStats")
          expect(log.status).to eq("error")
          expect(log.error).to start_with("Failed to open TCP connection")
        end
      end
    end
  end
end
