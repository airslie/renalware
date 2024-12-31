module Renalware
  module HD
    describe SlotRequests::AccessState do
      it :aggregate_failures do
        is_expected.to validate_presence_of(:name)
        is_expected.to have_many(:slot_requests)
      end

      describe "name uniqueness" do
        subject { described_class.new(name: "ABC") }

        it { is_expected.to validate_uniqueness_of(:name) }
      end

      describe "ordered scope" do
        it "orders by position first then name" do
          locations = [
            described_class.create(name: "A"), # implicit position 0
            described_class.create(name: "B", position: 3),
            described_class.create(name: "c") # implicit position 0
          ]

          expect(described_class.ordered.pluck(:id)).to eq [
            locations[0].id,
            locations[2].id,
            locations[1].id
          ]
        end
      end
    end
  end
end
