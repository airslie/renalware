module Renalware
  describe Letters::QueueForDocumentRepositoryExport do
    include LettersSpecHelper

    let(:patient) { create(:letter_patient, :minimal) }
    let(:user) { create(:user, :minimal) }
    let(:approved_letter) do
      create_letter(
        state: :approved,
        to: :patient,
        patient:,
        author: user,
        approved_by: user,
        by: user
      )
    end

    it "creates an outgoing document when document repository integration is enabled" do
      allow(Renalware.config).to receive(:feeds_outgoing_documents_enabled).and_return(true)

      expect {
        described_class.call(letter: approved_letter)
      }.to change(Renalware::Feeds::OutgoingDocument, :count).by(1)

      outgoing_document = Renalware::Feeds::OutgoingDocument.last

      expect(outgoing_document.renderable).to eq(Renalware::Letters::Letter.find(approved_letter.id))
      expect(outgoing_document.created_by).to eq(user)
    end

    it "does not create an outgoing document when document repository integration is disabled" do
      allow(Renalware.config).to receive(:feeds_outgoing_documents_enabled).and_return(false)

      expect {
        described_class.call(letter: approved_letter)
      }.not_to change(Renalware::Feeds::OutgoingDocument, :count)
    end
  end
end
