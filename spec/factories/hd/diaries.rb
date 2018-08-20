# frozen_string_literal: true

FactoryBot.define do
  factory :hd_weekly_diary, class: "Renalware::HD::WeeklyDiary" do
    year { 2017 }
    week_number { 2 }
    master { false }
    association :master_diary, factory: :hd_master_diary
  end

  factory :hd_master_diary, class: "Renalware::HD::MasterDiary" do
    master { true }
  end
end
