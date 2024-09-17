# frozen_string_literal: true

require "net/sftp"

describe Renalware::UKRDC::Outgoing::TransferFilesJob do
  context "when there is an error connecting over SSH" do
    it "logs the error and re-raises the exception" do
      allow(Net::SSH)
        .to receive(:start)
        .and_raise(Errno::ECONNREFUSED, "Error with connection")

      expect {
        described_class.perform_now
      }.to raise_error(Errno::ECONNREFUSED)
        .and change(Renalware::System::APILog, :count).by(1)

      api_log = Renalware::System::APILog.last

      expect(api_log).to have_attributes(
        identifier: "SFTP UKRDC",
        status: "error",
        records_added: 0
      )
      expect(api_log.error).to match("Error with connection")
    end
  end
end
