module Renalware::Drugs::DMD::APISynchronisers
  describe FullAPISynchroniser do
    describe "#call" do
      let(:form_synchroniser) { instance_double FormSynchroniser, call: nil }
      let(:route_synchroniser) { instance_double RouteSynchroniser, call: nil }
      let(:unit_of_measure_synchroniser) {
        instance_double UnitOfMeasureSynchroniser, call: nil
      }
      let(:vtm_synchroniser) { instance_double VirtualTherapeuticMoietySynchroniser, call: nil }
      let(:vmp_synchroniser) { instance_double VirtualMedicalProductSynchroniser, call: nil }
      let(:atc_code_synchroniser) { instance_double AtcCodeSynchroniser, call: nil }
      let(:amp_synchroniser) { instance_double ActualMedicalProductSynchroniser, call: nil }
      let(:trade_family_synchroniser) { instance_double TradeFamilySynchroniser, call: nil }
      let(:amp_trade_family_synchroniser) { instance_double AmpTradeFamilySynchroniser, call: nil }

      before do
        allow(FormSynchroniser).to receive(:new) { form_synchroniser }
        allow(RouteSynchroniser).to receive(:new) { route_synchroniser }
        allow(UnitOfMeasureSynchroniser).to receive(:new) { unit_of_measure_synchroniser }
        allow(VirtualTherapeuticMoietySynchroniser).to receive(:new) { vtm_synchroniser }
        allow(VirtualMedicalProductSynchroniser).to receive(:new) { vmp_synchroniser }
        allow(AtcCodeSynchroniser).to receive(:new) { atc_code_synchroniser }
        allow(ActualMedicalProductSynchroniser).to receive(:new) { amp_synchroniser }
        allow(TradeFamilySynchroniser).to receive(:new) { trade_family_synchroniser }
        allow(AmpTradeFamilySynchroniser).to receive(:new) { amp_trade_family_synchroniser }
      end

      it "synchronises all DM+D data from an API" do
        described_class.new.call

        expect(form_synchroniser).to have_received(:call)
        expect(route_synchroniser).to have_received(:call)
        expect(unit_of_measure_synchroniser).to have_received(:call)
        expect(vtm_synchroniser).to have_received(:call)
        expect(vmp_synchroniser).to have_received(:call)
        expect(atc_code_synchroniser).to have_received(:call)
        expect(amp_synchroniser).to have_received(:call)
        expect(trade_family_synchroniser).to have_received(:call)
        expect(amp_trade_family_synchroniser).to have_received(:call)
      end
    end
  end
end
