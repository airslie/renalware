FactoryBot.define do
  factory :letter_letterhead, class: "Renalware::Letters::Letterhead" do
    name { "KCH" }
    site_code { "KCH" }
    unit_info { "KCH" }
    trust_name { "KCH TRUST" }
    trust_caption { "KCH TRUST" }
    site_info { "Lorem ipsum" }
  end
end
