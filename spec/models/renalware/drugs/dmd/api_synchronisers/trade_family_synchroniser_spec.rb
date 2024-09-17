# frozen_string_literal: true

module Renalware
  module Drugs::DMD
    describe APISynchronisers::TradeFamilySynchroniser do
      describe "#call" do
        let(:instance) {
          described_class.new(trade_family_repository: trade_family_repository)
        }

        let(:trade_family_repository) {
          instance_double(Repositories::TradeFamilyRepository, call: [])
        }

        context "with no entries" do
          it "does nothing" do
            instance.call

            expect(Drugs::TradeFamily.count).to eq 0
          end
        end

        context "with an entry" do
          let(:entry) do
            instance_double(
              Repositories::TradeFamilyRepository::Entry,
              code: "code",
              name: "name"
            )
          end

          before do
            allow(trade_family_repository).to receive(:call)
              .and_return([entry], [])
          end

          context "when entry with same code doesn't exist" do
            it "inserts it" do
              instance.call

              expect(Drugs::TradeFamily.count).to eq 1

              item = Drugs::TradeFamily.first
              expect(item.code).to eq "code"
              expect(item.name).to eq "name"
            end
          end

          context "when entry with same code exists" do
            it "updates it" do
              create(:drug_trade_family,
                     code: "code",
                     name: "Some other name")

              expect(Drugs::TradeFamily.find_by(code: "code").name).to eq "Some other name"

              instance.call

              expect(Drugs::TradeFamily.count).to eq 1

              item = Drugs::TradeFamily.first
              expect(item.code).to eq "code"
              expect(item.name).to eq "name"
            end
          end
        end
      end
    end
  end
end
