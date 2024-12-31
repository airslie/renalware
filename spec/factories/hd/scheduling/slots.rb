FactoryBot.define do
  factory :hd_diary_slot, class: "Renalware::HD::Scheduling::DiarySlot" do
    diurnal_period_code_id factory: %i(hd_diurnal_period_code am)
    patient
    station factory: %i(hd_station)
  end
end
