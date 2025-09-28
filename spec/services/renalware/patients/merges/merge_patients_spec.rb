module Renalware
  module Patients::Merges
    describe MergePatients do
      subject(:service) { described_class.new(merge:) }
      let(:merge) { create(:patient_merge, major_patient: major, minor_patient: minor) }
      let(:major) { create(:patient) }
      let(:minor) { create(:patient) }

      def stub_mergeable_tables_query_to_events_only
        allow(MergeableTablesQuery).to receive(:call).and_return(
          [ColumnReference.new("renalware", "events", "patient_id")]
        )
      end

      def create_default_merge_rule
        create(:patient_merge_rule, schema_name: "renalware", table_name: "*")
      end

      before do
        create_default_merge_rule
        stub_mergeable_tables_query_to_events_only
      end

      describe "#call" do
        # rubocop:disable RSpec/ChangeByZero
        context "when the merge is valid" do
          before do
            # Create some events for each patient. The 2 for the minor patient should be
            # reassigned to the major patient
            create(:simple_event, patient: major)
            create_list(:simple_event, 2, patient: minor)

            service
          end

          # rubocop:disable RSpec/ExampleLength
          # rubocop:disable RSpec/MultipleExpectations
          it "merges the minor patient into the major patient and marks the merge as completed" do
            old_updated_at = 1.day.ago
            major.update_column(:updated_at, old_updated_at)
            minor.update_column(:updated_at, old_updated_at)

            minor_events_ids_bf_merging = Renalware::Events::Event.for_patient(minor.id).pluck(:id)

            freeze_time do
              expect {
                described_class.new(merge:).call
              }.to change(Merge, :count).by(0) # No new merges created
                .and change(Merge.status_completed, :count).by(1)
                .and change(Merge.status_in_progress, :count).by(-1)
                .and change(Operation, :count).by(1) # 1 per table
                .and change(Log, :count).by(2) # 2 rows will be updated
                .and change(major, :updated_at).from(old_updated_at).to(Time.current)
                .and change(minor, :updated_at).from(old_updated_at).to(Time.current)

              merge.reload
              minor.reload
              major.reload

              expect(merge).to have_attributes(
                status: "completed",
                failure_message: nil,
                updated_at: Time.current
              )
              expect(minor).to have_attributes(merged_into_patient_id: major.id)
              operation = merge.operations.first
              expect(operation).to have_attributes(
                column_reference: have_attributes(
                  schema: "renalware", table: "events", column: "patient_id"
                ),
                merged: true,
                warning: nil,
                updated_count: 2
              )
              expect(operation.logs.count).to eq(2)
              expect(operation.logs.pluck(:id_of_updated_record).sort)
                .to eq(minor_events_ids_bf_merging.sort)

              updated_events = Renalware::Events::Event.where(id: minor_events_ids_bf_merging)
              expect(updated_events.count).to eq(2)
              expect(
                updated_events.pluck(:updated_at).uniq.map { it.change(usec: 0) }
              ).to eq([Time.current])
              expect(updated_events.pluck(:patient_id).uniq).to eq([major.id])

              expect(Events::Event.for_patient(minor.id).count).to eq(0)
              expect(Events::Event.for_patient(major.id).count).to eq(3)
            end
          end
          # rubocop:enable RSpec/ExampleLength
          # rubocop:enable RSpec/MultipleExpectations
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
