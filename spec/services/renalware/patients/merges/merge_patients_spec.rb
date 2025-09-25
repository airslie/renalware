module Renalware
  module Patients::Merges
    describe MergePatients do
      subject(:service) { described_class.new(merge:) }

      let(:merge) { create(:patient_merge) }
      let(:major_patient) { merge.major_patient }
      let(:minor_patient) { merge.minor_patient }

      before { create(:patient_merge_rule, schema_name: "renalware", table_name: "*") }

      describe "#call" do
        # rubocop:disable RSpec/ChangeByZero
        context "when the merge is valid" do
          it "merges the patients and marks the merge as completed" do
            service
            expect {
              service.call
            }.to change(Merge, :count).by(0) # No new merges created
              .and change { Merge.where(status: :completed).count }.by(1)

            expect(merge.reload.status).to eq("completed")
            expect(minor_patient.reload.merged_into_patient_id).to eq(major_patient.id)
          end
        end
        # rubocop:enable RSpec/ChangeByZero

        context "when the merge fails" do
          # before do
          #   # do something to make the merge fail??
          #   # allow(merge).to receive(:persisted?).and_return(false)
          # end

          it "marks the merge as failed with an error message" do
            expect {
              service.call
            }.to change { Patients::Merges::Merge.where(status: :failed).count }.by(1)

            expect(merge.reload.status).to eq("failed")
            expect(merge.failure_message).to include("Merge failed")
          end
        end
      end
    end
  end
end
