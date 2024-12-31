FactoryBot.define do
  factory :country, class: "Renalware::System::Country" do
    factory :united_kingdom do
      name { "United Kingdom" }
      alpha2 { "GB" }
      alpha3 { "GBR" }
    end

    factory :algeria do
      name { "Algeria" }
      alpha2 { "DZ" }
      alpha3 { "DZA" }
    end
  end
end
