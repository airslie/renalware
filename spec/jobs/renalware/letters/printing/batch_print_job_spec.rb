# frozen_string_literal: true

module Renalware
  module Letters
    module Printing
      describe BatchPrintJob do
        it "delegates to BatchCompilePdfs" do
          batch = Object.new
          user = Object.new
          allow(BatchCompilePdfs).to receive(:call)

          described_class.new.perform(batch, user)

          expect(BatchCompilePdfs).to have_received(:call).with(batch, user)
        end
      end
    end
  end
end
