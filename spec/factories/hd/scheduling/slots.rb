FactoryBot.define do
  factory :hd_diary_slot, class: "Renalware::HD::Scheduling::DiarySlot" do
    accountable
    diurnal_period_code factory: %i(hd_diurnal_period_code am)
    patient factory: :hd_patient
    station factory: %i(hd_station)
    diary factory: %i(hd_weekly_diary)
    day_of_week { 1 }
  end
end
