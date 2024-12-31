FactoryBot.define do
  factory :pd_regime_bag, class: "Renalware::PD::RegimeBag" do
    bag_type
    volume { 200 }
    monday { true }
    tuesday { false }
    wednesday { true }
    thursday { false }
    friday { true }
    saturday { false }
    sunday { false }
    role { :ordinary }

    trait :weekdays_only do
      monday { true }
      tuesday { true }
      wednesday { true }
      thursday { true }
      friday { true }
      saturday { false }
      sunday { false }
    end

    trait :weekend_only do
      monday { false }
      tuesday { false }
      wednesday { false }
      thursday { false }
      friday { false }
      saturday { true }
      sunday { true }
    end

    trait :everyday do
      monday { true }
      tuesday { true }
      wednesday { true }
      thursday { true }
      friday { true }
      saturday { true }
      sunday { true }
    end
  end
end
