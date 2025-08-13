FactoryBot.define do
  factory :api_log, class: "Renalware::System::APILog" do
    identifier { "A1" }
    status { Renalware::System::APILog::STATUS_DONE }

    trait :done do
      status { Renalware::System::APILog::STATUS_DONE }
    end

    trait :working do
      status { Renalware::System::APILog::STATUS_WORKING }
    end

    trait :error do
      status { Renalware::System::APILog::STATUS_ERROR }
    end
  end
end
