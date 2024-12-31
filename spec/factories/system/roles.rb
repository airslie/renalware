FactoryBot.define do
  factory :role, class: "Renalware::Role" do
    initialize_with { Renalware::Role.find_or_create_by(name: name) }

    name { :super_admin }
    hidden { false }

    trait :super_admin do
      name { :super_admin }
      hidden { true }
    end

    trait :admin do
      name { :admin }
    end

    trait :clinical do
      name { :clinical }
    end

    trait :read_only do
      name { :read_only }
    end

    trait :prescriber do
      name { :prescriber }
    end

    trait :hd_prescriber do
      name { :hd_prescriber }
    end
  end
end
