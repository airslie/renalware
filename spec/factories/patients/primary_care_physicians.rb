FactoryBot.define do
  sequence :gp_code do |n|
    "G#{n.to_s.rjust(7, '0')}"
  end

  factory :primary_care_physician, class: "Renalware::Patients::PrimaryCarePhysician" do
    name { "GOOD PJ" }
    telephone { "0203593082" }
    code { generate(:gp_code) }
    practitioner_type { "GP" }

    after(:build) do |record|
      if record.address.nil?
        record.address = build(:address, addressable: record)
      end
    end
  end
end
