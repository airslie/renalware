FactoryBot.define do
  factory :address, class: "Renalware::Address" do
    street_1 { "123 Legoland" }
    street_2 { "Brewster Road" }
    street_3 { "Brownswater" }
    town { "Windsor" }
    county { "Berkshire" }
    country { Renalware::System::Country.find_by(alpha2: "GB") }
    postcode { "NW1 6BB" }

    after(:build) do |record|
      if record.addressable.nil?
        # Uses a Renalware::Patients::Patient as the default addressable
        # to make the factory valid.
        record.addressable = build(:patient, current_address: record)
      end
    end

    trait :in_uk do
      country factory: %i(united_kingdom)
    end
  end
end
