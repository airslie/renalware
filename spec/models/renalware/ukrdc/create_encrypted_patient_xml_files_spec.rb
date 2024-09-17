# frozen_string_literal: true

module Renalware
  # describe UKRDC::CreateEncryptedPatientXmlFiles do
  #   let(:patient) do
  #     create(
  #       :patient,
  #       ukrdc_external_id: SecureRandom.uuid,
  #       send_to_rpv: true,
  #       sent_to_ukrdc_at: nil,
  #       updated_at: 1.day.ago
  #     )
  #   end

  #   # TODO: Removing tests for now as getting errors encypting files on CircleCI and need to look
  #   # into it when more time.
  #   # describe "#call" do
  #   # This causes an error on CircleCI:
  #   # RuntimeError:
  #   # Error encrypting UKRDC files: gpg: can't create `/home/circleci/.gnupg/random_seed':
  #   #   No such file or directory
  #   around(:each) do |example|
  #     # Create a sandboxed temp dir in the Rails tmp folder for us to use for
  #     # creating UKRDC files. Normally this location would be persistent e.g. at
  #     # /var/ukrdc
  #     rails_tmp_folder = Rails.root.join("tmp").to_s
  #     Dir.mktmpdir(nil, rails_tmp_folder) do |dir|
  #       Renalware.configure{ |config| config.ukrdc_working_path = dir }
  #       example.run
  #     end
  #   end

  #   context "when the operation succeeds" do
  #     it "updates sent_to_ukrdc_at for each sent patient" do
  #       travel_to(Time.zone.now) do
  #         patient

  #         expect {
  #           described_class.new.call
  #         }.to change{ patient.reload.sent_to_ukrdc_at }.to(Time.zone.now)
  #       end
  #     end
  #   end

  #   context "when then operation fails becuase the files canot be encryted" do
  #     before do
  #       # Force an encryption error
  #       Renalware.configure { |config| config.ukrdc_gpg_keyring = "bad" }
  #     end

  #     it "rolls back the transaction so sent_to_ukrdc_at is not updated" do
  #       travel_to(Time.zone.now) do
  #         patient

  #         expect {
  #           described_class.new.call
  #         }.to raise_error(RuntimeError)
  #         expect(patient.reload.sent_to_ukrdc_at).to be_nil # unchanged
  #       end
  #     end
  #   end
  # end
end
