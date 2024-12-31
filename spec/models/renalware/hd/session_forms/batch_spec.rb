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
      end
    end
  end
end
