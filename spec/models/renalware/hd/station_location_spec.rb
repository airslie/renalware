module Renalware::HD
  describe StationLocation do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:name)
      is_expected.to validate_presence_of(:colour)
      is_expected.to have_db_index(:name)
    end

    describe "#name uniqueness" do
      subject { described_class.new(name: "Antechamber", colour: "red") }

      it { is_expected.to validate_uniqueness_of(:name) }
    end
  end
end
