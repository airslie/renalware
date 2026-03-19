module Renalware
  describe Events::CreateEvent do
    subject(:service) do
      described_class.new(event:, by: user).broadcasting_to_configured_subscribers
    end

    let(:patient) { create(:patient, :minimal) }
    let(:user) { create(:user) }
    let(:event_type) do
      create(:simple_event_type, save_pdf_to_electronic_public_register: exportable)
    end
    let(:exportable) { true }
    let(:event) { build(:simple_event, patient:, event_type:, by: user) }

    before do
      allow(Renalware.config).to receive(:feeds_outgoing_documents_enabled).and_return(true)
    end

    it "creates an outgoing document when the event type is exportable" do
      expect {
        service.call
      }.to change(Renalware::Feeds::OutgoingDocument, :count).by(1)

      outgoing_document = Renalware::Feeds::OutgoingDocument.last

      expect(outgoing_document.renderable).to eq(event)
      expect(outgoing_document.created_by).to eq(user)
    end

    it "does not create an outgoing document when feeds outgoing documents are disabled" do
      allow(Renalware.config).to receive(:feeds_outgoing_documents_enabled).and_return(false)

      expect {
        service.call
      }.not_to change(Renalware::Feeds::OutgoingDocument, :count)
    end

    it "does not create an outgoing document when the event type is not exportable" do
      allow(event_type).to receive(:save_pdf_to_electronic_public_register?).and_return(false)

      expect {
        service.call
      }.not_to change(Renalware::Feeds::OutgoingDocument, :count)
    end

    it "does not create an outgoing document when the event is invalid" do
      event.date_time = nil

      expect {
        service.call
      }.not_to change(Renalware::Feeds::OutgoingDocument, :count)
    end
  end
end
