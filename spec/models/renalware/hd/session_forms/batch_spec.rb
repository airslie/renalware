module Renalware
  module HD
    module SessionForms
      describe Batch do
        it_behaves_like "an Accountable model"
        it { is_expected.to have_many :items }

        describe "#status" do
          it "defaults to queued" do
            expect(described_class.new).to have_attributes(
              queued?: true,
              processing?: false,
              failure?: false,
              success?: false
            )
          end
        end

        describe "#percent_complete" do
          context "when batch_items_count is nil" do
            it "returns 0 without raising an error" do
              batch = described_class.new
              batch.batch_items_count = nil

              expect { batch.percent_complete }.not_to raise_error
              expect(batch.percent_complete).to eq(0)
            end
          end

          context "when batch_items_count is zero" do
            it "returns 0 without raising an error" do
              batch = described_class.new
              batch.batch_items_count = 0

              expect { batch.percent_complete }.not_to raise_error
              expect(batch.percent_complete).to eq(0)
            end
          end
        end
      end
    end
  end
end
