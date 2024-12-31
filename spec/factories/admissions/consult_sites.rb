FactoryBot.define do
  factory :admissions_consult_site, class: "Renalware::Admissions::ConsultSite" do
    # accountable
    name { Faker::Company.name }
  end
end
