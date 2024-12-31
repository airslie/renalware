describe Renalware::Transplants::ConsentPresenter do
  let(:example_consent_class) { Renalware::Transplants::RecipientWorkupDocument::MarginalConsent }

  describe "#to_s" do
    context "when date and value (eg :yes) are present" do
      it "renders the consented_on data and value as a string" do
        consent = example_consent_class.new(
          value: :yes,
          consented_on: "2010-01-01"
        )
        expect(described_class.new(consent).to_s).to eq("01-Jan-2010 Yes")
      end
    end

    context "when no date is present, only the value" do
      it "renders just the value as a string" do
        consent = example_consent_class.new(value: :yes)
        expect(described_class.new(consent).to_s).to eq(" Yes")
      end
    end
  end
end
