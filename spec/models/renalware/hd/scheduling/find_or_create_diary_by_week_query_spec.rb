module Renalware::HD
  describe Scheduling::FindOrCreateDiaryByWeekQuery do
    let(:week_period) { WeekPeriod.from_date(Time.zone.today) }
    let(:user) { create(:user) }
    let(:unit) { create(:hospital_unit) }

    it "finds an existing diary for the given week period" do
      master_diary = create(
        :hd_master_diary,
        hospital_unit_id: unit.id,
        by: user
      )
      created_diary = create(
        :hd_weekly_diary,
        master_diary: master_diary,
        hospital_unit_id: unit.id,
        week_number: week_period.week_number,
        year: week_period.year,
        by: user
      )

      found_diary = described_class.new(by: user,
                                        unit_id: unit.id,
                                        week_period: week_period).call

      expect(found_diary.id).to eq(created_diary.id)
    end

    it "creates a new diary if one does not exists for the given week period" do
      diary = described_class.new(by: user,
                                  unit_id: unit.id,
                                  week_period: week_period).call

      expect(diary.week_number).to eq(week_period.week_number)
      expect(diary.year).to eq(week_period.year)
      expect(diary.hospital_unit_id).to eq(unit.id)
    end
  end
end
