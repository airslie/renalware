describe "Managing Diaries" do
  describe "GET edit a weekly diary" do
    it "creates the diary for the requested week (and the missing unit master diary), " \
       "and renders the diary for editing" do
      unit = create(:hospital_unit)

      get hd_scheduling_unit_edit_diary_path(unit, week_number: 33, year: 2018)

      expect(response).to be_successful
      weekly_diaries = Renalware::HD::Scheduling::WeeklyDiary.where(hospital_unit_id: unit.id)
      expect(weekly_diaries.count).to eq(1)

      weekly_diary = weekly_diaries.first
      expect(weekly_diary.week_number).to eq(33)
      expect(weekly_diary.year).to eq(2018)

      expect(weekly_diary.master_diary).to be_present
    end
  end

  describe "GET index" do
    it "renders a list of diaries for for a hospital unit" do
      unit = create(:hospital_unit)
      get hd_scheduling_unit_diaries_path(unit)

      expect(response).to be_successful
    end
  end
end
