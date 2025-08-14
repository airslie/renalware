FactoryBot.define do
  factory :united_kingdom, class: "Renalware::System::Country" do
    name { "United Kingdom" }
    alpha2 { "GB" }
    alpha3 { "GBR" }
  end

  factory :algeria, class: "Renalware::System::Country" do
    name { "Algeria" }
    alpha2 { "DZ" }
    alpha3 { "DZA" }
  end
end
