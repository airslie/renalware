# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe Letters::ApproveLetter do
    include LettersSpecHelper
    subject(:service) do
      described_class
        .build(letter)
        .broadcasting_to_configured_subscribers
    end

    let(:patient) { create(:letter_patient) }
    let(:user) { create(:user) }
    let(:letter) { create_letter(state: :pending_review, to: :patient, patient: patient) }
    let(:approved_letter) { letter.becomes(Letters::Letter::Approved) }

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
      patient
      expect {
        service.call(by: user)
      }.to change(patient, :updated_at)
    end

    describe "broadcasting" do
      it "broadcasts a letter_approved event when the letter is approved successfully" do
        expect {
          service.call(by: user)
        }.to broadcast(:letter_approved, approved_letter.becomes(Renalware::Letters::Letter))
      end

      describe "async listeners" do
        let(:adapter) { ActiveJob::Base.queue_adapter }

        before do
          ActiveJob::Base.queue_adapter = :test
          ActiveJob::Base.queue_adapter.enqueued_jobs.clear
        end

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
                [approved_letter]
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
              [approved_letter]
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
