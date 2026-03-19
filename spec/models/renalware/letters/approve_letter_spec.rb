module Renalware
  describe Letters::ApproveLetter do
    include LettersSpecHelper

    subject(:service) do
      described_class
        .build(letter)
        .broadcasting_to_configured_subscribers
    end

    let(:patient) { create(:letter_patient, :minimal) }
    let(:user) { create(:user, :minimal) }
    let(:letter) { create_letter(state: :pending_review, to: :patient, patient:) }
    let(:approved_letter) { letter.becomes(Letters::Letter::Approved) }

    before do
      ActiveJob::Base.queue_adapter = :test
      ActiveJob::Base.queue_adapter.enqueued_jobs.clear
      allow(Renalware.config).to receive_messages(
        send_gp_letters_over_mesh: true,
        feeds_outgoing_documents_enabled: false
      )
    end

    it "updates when and by who the letter was approved" do
      time = Time.zone.now
      travel_to(time) do
        service.call(by: user)
      end

      approved_letter.reload
      expect(approved_letter.approved_by).to eq(user)
      expect(approved_letter.approved_at.to_s).to eq(time.to_s)
    end

    it "touches the patient" do
      expect {
        service.call(by: user)
      }.to change(patient, :updated_at)
    end

    it "sets gp send status to pending if there is a gp recipient" do
      expect(letter.gp_send_status).to eq("not_applicable")

      service.call(by: user)

      expect(letter.becomes(Renalware::Letters::Letter).reload.gp_send_status).to eq("pending")
    end

    it "sets gp send status to not_applicable if patient confidentiality is restricted" do
      patient.update_column(:confidentiality, :restricted)
      expect(letter.gp_send_status).to eq("not_applicable")

      service.call(by: user)

      expect(
        letter.becomes(Renalware::Letters::Letter).reload.gp_send_status
      ).to eq("not_applicable")
    end

    it "sets gp send status to not_applicable if the gp is not among the recipients" do
      # Remove the patients GP so they are not automatically added as a CC
      # in DetermineCounterpartCCs.
      expect(letter.gp_send_status).to eq("not_applicable")
      patient.primary_care_physician = patient.practice = nil
      patient.save_by!(user)

      service.call(by: user)

      # Cast the letter to a base Letter so it can be found when reloading (otherwise letter class)
      # is PendingApproval and reloading fails as a PendingApproval letter with the current id
      # no longer exists - its now Approved
      expect(
        letter.becomes(Renalware::Letters::Letter).reload.gp_send_status
      ).to eq("not_applicable")
    end

    describe "document repository export" do
      it "creates an outgoing document when document repository integration is enabled" do
        allow(Renalware.config)
          .to receive(:feeds_outgoing_documents_enabled)
          .and_return(true)

        expect {
          service.call(by: user)
        }.to change(Renalware::Feeds::OutgoingDocument, :count).by(1)

        outgoing_document = Renalware::Feeds::OutgoingDocument.last

        expect(outgoing_document.renderable).to eq(approved_letter.reload)
        expect(outgoing_document.created_by).to eq(user)
      end

      it "does not create an outgoing document when document repository integration is disabled" do
        allow(Renalware.config)
          .to receive(:feeds_outgoing_documents_enabled)
          .and_return(false)

        expect {
          service.call(by: user)
        }.not_to change(Renalware::Feeds::OutgoingDocument, :count)
      end
    end

    describe "electronic delivery to gp" do
      it "creates a transmission after approval when a gp should receive it" do
        expect {
          service.call(by: user)
        }.to change(Renalware::Letters::Transports::Mesh::Transmission, :count).by(1)

        transmission = Renalware::Letters::Transports::Mesh::Transmission.last

        expect(transmission.letter).to eq(approved_letter.reload)
        expect(transmission.active_job_id).to be_present
      end

      it "does not create a transmission or enqueue a mesh send job " \
         "when a gp should not receive it" do
        patient.update_column(:confidentiality, :restricted)

        expect {
          service.call(by: user)
        }.not_to change(Renalware::Letters::Transports::Mesh::Transmission, :count)
      end
    end

    describe "broadcasting" do
      it "broadcasts a letter_approved event when the letter is approved successfully" do
        expect {
          service.call(by: user)
        }.to broadcast(:letter_approved, approved_letter.becomes(Renalware::Letters::Letter))
      end

      describe "async listeners" do
        let(:adapter) { ActiveJob::Base.queue_adapter }

        context "when using wicked_pdf/wkhtmltopdf" do
          before do
            allow(Renalware.config.broadcast_subscription_map)
              .to receive(:[])
              .with("Renalware::Letters::ApproveLetter")
              .and_return(
                Renalware::Broadcasting::Subscriber.new(
                  "Renalware::Letters::CalculatePageCountJob",
                  async: true
                )
              )
          end

          it "queues a job to calculate the page size" do
            service.call(by: user)

            expect(Wisper::ActiveJobBroadcaster::Wrapper).to(
              have_been_enqueued.with(
                "Renalware::Letters::CalculatePageCountJob",
                "letter_approved",
                approved_letter
              )
            )
          end
        end
      end

      context "when using prawn" do
        before do
          allow(Renalware.config).to receive(:letters_render_pdfs_with_prawn).and_return(true)
          Renalware.config.broadcast_subscription_map["Renalware::Letters::ApproveLetter"] = []
        end

        it "does NOT queue a job to calculate the page size" do
          service.call(by: user)

          expect(Wisper::ActiveJobBroadcaster::Wrapper).not_to(
            have_been_enqueued.with(
              "Renalware::Letters::CalculatePageCountJob",
              "letter_approved",
              approved_letter
            )
          )
        end

        it "calculates and stores the the page_count in real time" do
          service.call(by: user)

          expect(approved_letter.page_count).to eq(1)
        end
      end
    end
  end
end
