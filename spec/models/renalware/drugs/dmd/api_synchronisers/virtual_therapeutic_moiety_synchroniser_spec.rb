module Renalware
  module Drugs::DMD
    describe APISynchronisers::VirtualTherapeuticMoietySynchroniser do
      describe "#call" do
        let(:instance) {
          described_class.new(vtm_repository: repository)
        }

        let(:repository) {
          instance_double(Repositories::VirtualTherapeuticMoietyRepository, call: [])
        }

        context "with no entries" do
          it "does nothing" do
            instance.call

            expect(VirtualTherapeuticMoiety.count).to eq 0
          end
        end

        context "with an entry" do
          let(:entry) do
            instance_double(
              Repositories::VirtualTherapeuticMoietyRepository::Entry,
              code: "code",
              name: "name",
              inactive: true
            )
          end

          before do
            allow(repository).to receive(:call)
              .and_return([entry], [])
          end

          context "when entry with same code doesn't exist" do
            it "inserts it" do
              instance.call

              expect(VirtualTherapeuticMoiety.count).to eq 1

              item = VirtualTherapeuticMoiety.first
              expect(item.code).to eq "code"
              expect(item.name).to eq "name"
              expect(item.inactive).to be true
            end
          end

          context "when entry with same code exists" do
            it "updates it" do
              create(:dmd_virtual_therapeutic_moiety,
                     code: "code",
                     inactive: false,
                     name: "Some other name")

              expect(VirtualTherapeuticMoiety.find_by(code: "code").name).to eq "Some other name"

              instance.call

              expect(VirtualTherapeuticMoiety.count).to eq 1

              item = VirtualTherapeuticMoiety.first
              expect(item.code).to eq "code"
              expect(item.name).to eq "name"
              expect(item.inactive).to be true
            end
          end
        end
      end
    end
  end
end
