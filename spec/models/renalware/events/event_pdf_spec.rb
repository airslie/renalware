module Renalware::Events
  describe EventPdf do
    describe "#render" do
      it "generates a PDF" do
        event = Renalware::Events::EventPdfPresenter.new(create(:simple_event))
        create(:hospital_centre, code: Renalware.config.ukrdc_site_code)

        expect(described_class.new(event).render).to start_with "%PDF-1.3"
      end
    end
  end
end
