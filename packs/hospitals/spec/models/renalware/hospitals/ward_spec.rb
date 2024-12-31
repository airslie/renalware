module Renalware::Hospitals
  describe Ward do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:name)
      is_expected.to validate_presence_of(:hospital_unit)
      is_expected.to belong_to(:hospital_unit)
    end

    describe "uniqueness" do
      subject { described_class.new(name: "X", hospital_unit_id: unit.id) }

      let(:unit) { create(:hospital_unit) }

      it { is_expected.to validate_uniqueness_of(:name).scoped_to(:hospital_unit_id) }
    end
  end
end
