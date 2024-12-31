FactoryBot.define do
  factory :apd_system, class: "Renalware::PD::System" do
    name { Faker::Company.name }
    pd_type { "APD" }
  end

  factory :capd_system, class: "Renalware::PD::System" do
    name { Faker::Company.name }
    pd_type { "CAPD" }
  end
end
