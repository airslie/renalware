FactoryBot.define do
  sequence :practice_code do |n|
    "M#{n.to_s.rjust(5, '0')}"
  end

  factory :practice, class: "Renalware::Patients::Practice" do
    name { "Trumpton Medical Centre" }
    email { "admin@trumptonmedicalcentre-nhs.net" }
    code { generate(:practice_code) }

    # ensures addressable_type and addressable_id work is assigned, using
    # FactoryBot's simple assoc method does not work
    #
    before(:create) do |practice|
      practice.build_address(attributes_for(:address))
    end
  end
end
