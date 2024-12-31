FactoryBot.define do
  factory :organism_code, class: "Renalware::PD::OrganismCode" do
    code { "7" }
    name { "Staphylococcus aureus" }
  end
end
