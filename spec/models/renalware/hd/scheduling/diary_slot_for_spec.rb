module Renalware::HD::Scheduling
  describe Diary, "#slot_for" do
    let(:user) { create(:user) }
    let(:am) { create(:hd_diurnal_period_code, :am) }
    let(:station) { create(:hd_station) }
    let(:unit) { station.hospital_unit }
    let(:master_diary) { create(:hd_master_diary, hospital_unit: unit) }
    let(:weekly_diary) { create(:hd_weekly_diary, master_diary:, hospital_unit: unit) }

    def create_slot(diary:, day_of_week: 1, **attrs)
      create(
        :hd_diary_slot,
        diary:,
        station:,
        diurnal_period_code: am,
        day_of_week:,
        by: user,
        **attrs
      )
    end

    context "with a weekly diary" do
      it "returns the matching slot decorated as not master" do
        slot = create_slot(diary: weekly_diary)

        found = weekly_diary.reload.slot_for(am.id, station.id, 1)

        expect(found).to eq(slot)
        expect(found).not_to be_master
      end

      it "returns nil when there is no matching slot" do
        create_slot(diary: weekly_diary, day_of_week: 1)

        expect(weekly_diary.reload.slot_for(am.id, station.id, 2)).to be_nil
      end
    end

    %w(2026-01-11 2026-03-29 2026-07-12 2026-10-25).each do |sunday|
      it "returns a master slot created at the end of Sunday #{sunday}" do
        slot = create_slot(
          diary: master_diary,
          created_at: Time.zone.parse("#{sunday} 23:59:59")
        )

        found = master_diary.reload.slot_for(
          am.id, station.id, 1, valid_from: Date.parse(sunday)
        )

        expect(found).to eq(slot)
      end
    end

    context "with a master diary" do
      it "returns the matching slot decorated as master" do
        slot = create_slot(diary: master_diary)

        found = master_diary.reload.slot_for(am.id, station.id, 1)

        expect(found).to eq(slot)
        expect(found).to be_master
      end

      it "ignores slots created after the end of the valid_from week" do
        create_slot(diary: master_diary, created_at: Time.zone.parse("2026-10-26 00:00:00"))

        found = master_diary.reload.slot_for(
          am.id, station.id, 1, valid_from: Date.new(2026, 10, 25)
        )

        expect(found).to be_nil
      end
    end
  end
end
