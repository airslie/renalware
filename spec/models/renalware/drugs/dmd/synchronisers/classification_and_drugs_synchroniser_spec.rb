# frozen_string_literal: true

module Renalware::Drugs::DMD::Synchronisers
  describe ClassificationAndDrugsSynchroniser do
    describe "#call" do
      let(:drug_sync) { instance_double DrugSynchroniser, call: nil }

      let(:vmp_sync) { instance_double VMPClassificationSynchroniser, call: nil }
      let(:trade_family_sync) { instance_double TradeFamilyClassificationSynchroniser, call: nil }
      let(:drug_type_sync) { instance_double DrugTypesClassificationSynchroniser, call: nil }

      before do
        allow(DrugSynchroniser).to receive(:new) { drug_sync }

        allow(VMPClassificationSynchroniser).to receive(:new) { vmp_sync }
        allow(TradeFamilyClassificationSynchroniser).to receive(:new) { trade_family_sync }
        allow(DrugTypesClassificationSynchroniser).to receive(:new) { drug_type_sync }
      end

      it "performs full DM+D synchronisation" do
        described_class.new.call

        expect(drug_sync).to have_received(:call)
        expect(vmp_sync).to have_received(:call)
        expect(trade_family_sync).to have_received(:call)
        expect(drug_type_sync).to have_received(:call)
      end
    end
  end
end
