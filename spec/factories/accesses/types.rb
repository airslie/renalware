FactoryBot.define do
  factory :access_type, class: "Renalware::Accesses::Type" do
    name { "Tunnelled subclav" }
    abbreviation { "TLN LS" }
    rr02_code { "TLN" }
    rr41_code { "LS" }
  end
end
