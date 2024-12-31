FactoryBot.define do
  factory :transplant_registration, class: "Renalware::Transplants::Registration" do
    # patient { build(:transplant_patient) }
    patient factory: %i(transplant_patient)

    trait :with_statuses do
      after(:create) do |registration|
        10.downto(8).each do |day|
          start_date = day.days.ago
          create(
            :transplant_registration_status,
            registration: registration,
            started_on: start_date,
            terminated_on: start_date + 1.day
          )
        end
        create(
          :transplant_registration_status,
          registration: registration,
          started_on: 7.days.ago
        )
      end
    end

    trait :in_status do
      transient do
        status { "active" }
      end

      after(:create) do |registration, evaluator|
        create(
          :transplant_registration_status,
          registration: registration,
          started_on: 7.days.ago,
          description: create(:transplant_registration_status_description,
                              name: evaluator.status.humanize, code: evaluator.status)
        )
        create(
          :transplant_registration_status,
          registration: registration,
          started_on: 10.days.ago,
          terminated_on: 7.days.ago
        )
      end
    end
  end
end
