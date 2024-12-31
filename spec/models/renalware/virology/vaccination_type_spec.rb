module Renalware
  describe Virology::VaccinationType do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to have_db_index(:name).unique(true) }
    it { is_expected.to have_db_index(:code).unique(true) }

    it "defaults position to 1 (by Sortable module)" do
      type = described_class.create!(name: "X", code: "X")

      expect(type.position).to eq(1)
    end

    describe "#ordered" do
      it do
        {
          "A" => 1,
          "B" => 3,
          "D" => 2,
          "C" => 2
        }.each do |code, position|
          # Sortable will initially assign the position with the next available value.
          # We want to test position explictly hence the save and subsequent update.
          type = described_class.create!(name: code, code: code)
          type.update!(position: position)
        end

        codes = described_class.ordered.map(&:code)
        expect(codes).to eq(%w(a c d b))
      end
    end
  end
end
