module Renalware
  module Transplants
    describe RecipientWorkupBuilder do
      it "assigns the default consenter if the workup is a new record" do
        consenter_name = "John Smith"

        workup = described_class.new(
          workup: RecipientWorkup.new,
          default_consenter_name: consenter_name
        ).build

        document = workup.document
        expect(document.consent.full_name).to eq(consenter_name)
        expect(document.marginal_consent.full_name).to eq(consenter_name)
        expect(document.nhb_consent.full_name).to eq(consenter_name)
      end

      it "does not assign the default consenter if the workup has already been saved" do
        consenter_name = "John Smith"
        workup = RecipientWorkup.new
        allow(workup).to receive(:new_record?).and_return(false)

        workup = described_class.new(
          workup: workup,
          default_consenter_name: consenter_name
        ).build

        document = workup.document
        expect(document.consent.full_name).to be_nil
        expect(document.marginal_consent.full_name).to be_nil
        expect(document.nhb_consent.full_name).to be_nil
      end
    end
  end
end
