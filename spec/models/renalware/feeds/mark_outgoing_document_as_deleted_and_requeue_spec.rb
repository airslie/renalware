module Renalware
  describe Feeds::MarkOutgoingDocumentAsDeletedAndRequeue do
    include LettersSpecHelper

    let(:patient) { create(:letter_patient) }
    let(:user) { create(:user) }
    let(:by) { user }

    def create_a_letter_outgoing_document(state: :processed, deleted_at: nil)
      letter = create_letter(
        to: :patient,
        state: :approved,
        patient:,
        description: "xxx",
        deleted_at:,
        by:
      )

      Feeds::OutgoingDocument.create!(renderable: letter, state:, by:)
    end

    def create_an_event_outgoing_document(state: :processed, deleted_at: nil)
      event = create(:swab, by:, patient:, deleted_at:)
      Feeds::OutgoingDocument.create!(renderable: event, state:, by:)
    end

    describe "#call" do
      context "when the renderable exists in outgoing_documents and has been processed" do
        it "re-queues it with a comment" do
          outgoing_document = create_a_letter_outgoing_document(deleted_at: Time.zone.now)
          expect(outgoing_document).to be_processed
          expect(outgoing_document.renderable).to be_a(Renalware::Letters::Letter)

          freeze_time do
            described_class.call(renderable: outgoing_document.renderable, by:)

            expect(outgoing_document.reload).to have_attributes(
              state: "queued",
              comments: "Requeued as document was deleted",
              updated_at: Time.zone.now
            )
          end
        end
      end

      context "when the renderable exists in outgoing_documents and is still queued" do
        it "re-queues it with a comment" do
          outgoing_document = create_a_letter_outgoing_document(
            state: :queued,
            deleted_at: Time.zone.now
          )

          expect(outgoing_document).to be_queued

          freeze_time do
            described_class.call(renderable: outgoing_document.renderable, by:)

            expect(outgoing_document.reload).to have_attributes(
              state: "queued",
              comments: "Requeued as document was deleted",
              updated_at: Time.zone.now
            )
          end
        end
      end

      context "when the renderable is an event rather than a letter" do
        it "re-queues it with a comment" do
          outgoing_document = create_an_event_outgoing_document(
            state: :processed,
            deleted_at: Time.zone.now
          )
          expect(outgoing_document).to be_processed
          expect(outgoing_document.renderable).to be_a(Renalware::Events::Event)

          freeze_time do
            described_class.call(renderable: outgoing_document.renderable, by:)

            expect(outgoing_document.reload).to have_attributes(
              state: "queued",
              comments: "Requeued as document was deleted",
              updated_at: Time.zone.now
            )
          end
        end
      end
    end
  end
end
