module Renalware::Drugs::DMD
  describe Synchronisers::FullSynchroniser do
    describe "#call" do
      let(:full_api_sync) { instance_double APISynchronisers::FullAPISynchroniser, call: nil }
      let(:classification_sync) {
        instance_double Synchronisers::ClassificationAndDrugsSynchroniser, call: nil
      }

      before do
        allow(APISynchronisers::FullAPISynchroniser).to \
          receive(:new) { full_api_sync }

        allow(Synchronisers::ClassificationAndDrugsSynchroniser).to \
          receive(:new) { classification_sync }
      end

      it "performs full DM+D synchronisation" do
        described_class.new.call

        expect(full_api_sync).to have_received(:call)
        expect(classification_sync).to have_received(:call)
      end
    end
  end
end
