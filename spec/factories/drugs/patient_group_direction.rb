FactoryBot.define do
  factory :patient_group_direction, class: "Renalware::Drugs::PatientGroupDirection" do
    name { "PGD1" }
    code { "pgd1_code" }
  end
end
