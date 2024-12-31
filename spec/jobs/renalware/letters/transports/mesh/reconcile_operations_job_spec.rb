module Renalware::Letters::Transports::Mesh
  describe ReconcileOperationsJob do
    include LettersSpecHelper
    include MeshSpecHelper

    let(:user) { create(:user) }
    let(:letter) { create_mesh_letter_to_gp(create_mesh_patient(user: user), user) }

    it "ignores Transmissions with no operations" do
      transmission = Transmission.create!(letter: letter)

      expect {
        described_class.perform_now
      }.not_to change { transmission.reload.status }
    end

    describe "operation errors" do
      it "does not touch Transmissions having non-download/send operation errors" do
        # Note this test scenario using 'handshake' is very unlikely (this operation should not be
        # associated with a transmission) but bolt and braces anyway.
        transmission = Transmission.create!(letter: letter)
        transmission.operations.create!(action: "handshake", http_error: true)

        expect {
          described_class.perform_now
        }.not_to change { transmission.reload.status }
      end

      it "flags pending transmissions as failed if any download_message operation has an error" do
        %i(
          http_error
          mesh_error
          itk3_error
        ).each do |attr_name|
          letter.update!(gp_send_status: :pending)
          transmission = Transmission.create!(letter: letter)
          transmission.operations.create!(action: "download_message", attr_name => true)

          expect {
            described_class.perform_now
          }.to change { transmission.reload.status }.from("pending").to("failure")

          expect(letter.reload.gp_send_status).to eq("failure")
        end
      end

      it "flags pending transmissions as failed if any send_message operation has an error" do
        %i(
          http_error
          mesh_error
          itk3_error
        ).each do |attr_name|
          transmission = Transmission.create!(letter: letter)
          transmission.operations.create!(action: "send_message", attr_name => true)

          expect {
            described_class.perform_now
          }.to change { transmission.reload.status }.from("pending").to("failure")
        end
      end
    end

    context "when a pending transmission has success inf and bus download operations" do
      # rubocop:disable Metrics/MethodLength
      def create_pending_transmission_with_successful_inf_and_bus_operations
        Transmission.create!(letter: letter, status: :pending).tap do |transmission|
          transmission.operations.create!(
            action: "download_message",
            itk3_response_type: "bus",
            itk3_operation_outcome_code: "30001"
          )
          transmission.operations.create!(
            action: "download_message",
            itk3_response_type: "inf",
            itk3_operation_outcome_code: "20013"
          )
          letter.update_column(:gp_send_status, "pending")
        end
      end
      # rubocop:enable Metrics/MethodLength

      it "flag as transmission and associated letter as successful" do
        transmission = create_pending_transmission_with_successful_inf_and_bus_operations

        expect {
          described_class.perform_now
        }.to change { transmission.reload.status }.from("pending").to("success")
          .and change { transmission.letter.gp_send_status }.from("pending").to("success")
      end

      context "when GP was the only recipient (ie no patient or contact recipients)" do
        it "'Completes' the letter using the approve_by user" do
          create_pending_transmission_with_successful_inf_and_bus_operations
          letter.update!(approved_by: user)
          expect(letter.recipients.count).to eq(1)
          expect(letter.recipients.first.person_role).to eq(:primary_care_physician)
          expect(letter.completed_at).to be_nil

          freeze_time do
            described_class.perform_now

            completed_letter = Renalware::Letters::Letter::Completed.find(letter.id)
            expect(completed_letter).to have_attributes(
              completed_at: Time.zone.now,
              completed_by: user
            )
          end
        end
      end
    end

    describe "no MESH response after configured period elapsed" do
      it "flags transmission as failed when x hours have elapsed and no response forthcoming" do
        # Create transmission with single send operation, no info or bus responses
        transmission = Transmission.create!(
          letter: letter,
          status: :pending,
          created_at: Time.zone.now
        )
        transmission.operations.create!(action: "send_message")
        letter.update!(gp_send_status: :pending)

        # Before the period has elapsed, no change
        expect {
          described_class.perform_now
        }.not_to change { transmission.reload.status }
        expect(letter.reload.gp_send_status).to eq("pending")

        travel_to 25.hours.from_now do
          # After the period has elapsed, new status will be failure as no corresponding
          # inf and bus responses to our send_message operation have been received.
          expect {
            described_class.perform_now
          }.to change { transmission.reload.status }.from("pending").to("failure")
          expect(letter.reload.gp_send_status).to eq("failure")
        end
      end
    end
  end
end
