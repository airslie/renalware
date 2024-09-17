# frozen_string_literal: true

module Renalware
  module HD
    module SessionForms
      describe BatchPrintJob do
        it "delegates to BatchCompilePdfs" do
          batch = instance_double(Batch, id: 1)
          user = instance_double(User, id: 1)
          allow(BatchCompilePdfs).to receive(:call)
          allow(User).to receive(:find).and_return(user)
          allow(Batch).to receive(:find).and_return(batch)

          described_class.perform_now(batch.id, user.id)

          expect(BatchCompilePdfs).to have_received(:call).with(batch, user)
        end
      end
    end
  end
end
