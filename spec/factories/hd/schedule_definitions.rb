FactoryBot.define do
  factory :schedule_definition, class: "Renalware::HD::ScheduleDefinition" do
    initialize_with do
      Renalware::HD::ScheduleDefinition.find_or_create_by(
        diurnal_period: diurnal_period,
        days: days
      )
    end

    trait :mon_wed_fri_am do
      days { [1, 3, 5] }
      days_text { "Mon Wed Fri" }
      diurnal_period factory: %i(hd_diurnal_period_code am)
    end

    trait :mon_wed_fri_pm do
      days { [1, 3, 5] }
      days_text { "Mon Wed Fri" }
      diurnal_period factory: %i(hd_diurnal_period_code pm)
    end
  end
end
