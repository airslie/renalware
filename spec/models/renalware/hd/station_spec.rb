module Renalware
  module HD
    describe Station do
      it_behaves_like "an Accountable model"
      it :aggregate_failures do
        is_expected.to validate_presence_of(:hospital_unit_id)
        is_expected.to belong_to(:location)
      end

      describe "#name is unique in the scope of the unit" do
        subject do
          described_class.new(name: station.name, hospital_unit_id: station.hospital_unit_id)
        end

        let(:user) { create(:user) }
        let(:unit) { create(:hospital_unit) }
        let(:station) { create(:hd_station, hospital_unit_id: unit.id, name: "A", by: user) }

        it { is_expected.to validate_uniqueness_of(:name).scoped_to(:hospital_unit_id) }
      end
    end
  end
end
