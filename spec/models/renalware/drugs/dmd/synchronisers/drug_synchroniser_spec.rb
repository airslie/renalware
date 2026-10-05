module Renalware
  module Drugs
    describe DMD::Synchronisers::DrugSynchroniser do
      describe "#call" do
        let(:instance) {
          described_class.new(vtm_repository:)
        }

        let(:vtm_repository) {
          instance_double(DMD::VirtualTherapeuticMoiety::ExportSyncQuery, call: [])
        }

        context "with no entries" do
          it "does nothing" do
            instance.call

            expect(Drug.count).to eq 0
          end
        end

        context "with an entry" do
          let(:entry) do
            instance_double(
              DMD::VirtualTherapeuticMoiety,
              code: "code",
              name: "name",
              inactive: true
            )
          end

          before do
            allow(vtm_repository).to receive(:call)
              .and_return([entry])
          end

          context "when entry with same code doesn't exist" do
            it "inserts it" do
              instance.call

              expect(Drug.count).to eq 1

              drug = Drug.first
              expect(drug.name).to eq "name"
              expect(drug.code).to eq "code"
              expect(drug.inactive).to be true
            end
          end

          context "when entry with same code exists" do
            it "updates it" do
              create(:drug,
                     code: "code",
                     inactive: false,
                     name: "Some other name")

              expect(Drug.find_by(code: "code").name).to eq "Some other name"

              instance.call

              expect(Drug.count).to eq 1

              drug = Drug.first
              expect(drug.code).to eq "code"
              expect(drug.name).to eq "name"
              expect(drug.inactive).to be true
            end
          end

          context "when entry with same code has been soft-deleted" do
            it "updates the drug without restoring it or changing its deletion timestamp" do
              drug = create(:drug, code: "code", name: "Some other name", inactive: false)
              drug.destroy!
              deleted_at = Drug.with_deleted.find(drug.id).deleted_at

              2.times { instance.call }

              expect(Drug.where(code: "code")).not_to exist
              expect(Drug.with_deleted.where(code: "code").count).to eq 1

              drug = Drug.with_deleted.find(drug.id)
              expect(drug.deleted_at).to eq deleted_at
              expect(drug.name).to eq "name"
              expect(drug.inactive).to be true
            end
          end
        end
      end
    end
  end
end
