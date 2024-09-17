# frozen_string_literal: true

module Renalware
  module Drugs::DMD
    describe SynchroniserJob do
      describe "#perform_now" do
        let(:synchroniser) { instance_double Synchronisers::FullSynchroniser, call: nil }

        before do
          allow(Synchronisers::FullSynchroniser).to receive(:new).and_return(synchroniser)
        end

        it "calls the full synchroniser" do
          expect {
            described_class.perform_now
          }.to change(System::APILog, :count).by(1)
          expect(synchroniser).to have_received(:call)
        end
      end
    end
  end
end
