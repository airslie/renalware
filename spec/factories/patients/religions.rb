FactoryBot.define do
  factory :patient_religion, class: "Renalware::Patients::Religion" do
    code { "B1" }
    name { "Buddhist" }
  end
end
