FactoryBot.define do
  factory :access_site, class: "Renalware::Accesses::Site" do
    name { "Femoral vein line" }
    code { "12" }
  end
end
