FactoryBot.define do
  factory :hd_preference_set, class: "Renalware::HD::PreferenceSet" do
    accountable
    patient factory: :hd_patient
    hospital_unit
    schedule_definition factory: %i(schedule_definition mon_wed_fri_pm)
    other_schedule { "" }
  end
end
