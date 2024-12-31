FactoryBot.define do
  factory :hd_weekly_diary, class: "Renalware::HD::Scheduling::WeeklyDiary" do
    accountable
    year { 2017 }
    week_number { 2 }
    master { false }
    hospital_unit_id { nil }
    master_diary factory: %i(hd_master_diary)
  end

  factory :hd_master_diary, class: "Renalware::HD::Scheduling::MasterDiary" do
    accountable
    master { true }
    hospital_unit_id { nil }
  end
end
