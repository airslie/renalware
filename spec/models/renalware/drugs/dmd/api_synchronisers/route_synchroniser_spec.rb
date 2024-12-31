module Renalware
  module Drugs::DMD
    describe APISynchronisers::RouteSynchroniser do
      describe "#call" do
        let(:instance) {
          described_class.new(route_repository: route_repository)
        }

        let(:route_repository) {
          instance_double(Repositories::RouteRepository, call: [])
        }

        context "with no entries" do
          it "does nothing" do
            instance.call

            expect(Medications::MedicationRoute.count).to eq 0
          end
        end

        context "with an entry" do
          let(:entry) do
            instance_double(
              Repositories::RouteRepository::Entry,
              code: "code",
              name: "name"
            )
          end

          before do
            allow(route_repository).to receive(:call)
              .and_return([entry], [])
          end

          context "when entry with same code doesn't exist" do
            it "inserts it" do
              instance.call

              expect(Medications::MedicationRoute.count).to eq 1

              item = Medications::MedicationRoute.first
              expect(item.code).to eq "code"
              expect(item.name).to eq "name"
            end
          end

          context "when entry with same code exists" do
            it "updates it" do
              create(:medication_route,
                     code: "code",
                     name: "Some other name")

              expect(Medications::MedicationRoute.find_by(code: "code").name).to eq \
                "Some other name"

              instance.call

              expect(Medications::MedicationRoute.count).to eq 1

              item = Medications::MedicationRoute.first
              expect(item.code).to eq "code"
              expect(item.name).to eq "name"
            end
          end
        end
      end
    end
  end
end
