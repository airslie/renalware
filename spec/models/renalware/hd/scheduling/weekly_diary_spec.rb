# frozen_string_literal: true

module Renalware::HD::Scheduling
  describe WeeklyDiary do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:week_number)
      is_expected.to validate_presence_of(:year)
      is_expected.to validate_inclusion_of(:week_number).in_range(1..53)
      is_expected.to belong_to(:master_diary)
      is_expected.to validate_presence_of(:master_diary)
    end

    describe "#master" do
      it "defaults to false" do
        expect(described_class.new.master).to be_falsey
      end
    end

    describe "the combination of #week_number and #year are unique in the scope of the unit" do
      subject do
        described_class.new(hospital_unit_id: unit.id, week_number: 1, year: 2017, by: user)
      end

      let(:user) { create(:user) }
      let(:unit) { create(:hospital_unit) }

      it do
        is_expected.to validate_uniqueness_of(:week_number).scoped_to(%i(year hospital_unit_id))
      end
    end
  end
end
