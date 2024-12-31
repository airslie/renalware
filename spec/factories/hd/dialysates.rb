FactoryBot.define do
  factory :hd_dialysate, class: "Renalware::HD::Dialysate" do
    initialize_with { Renalware::HD::Dialysate.find_or_create_by(name: name) }
    name { "Fresenius A7" }
    sodium_content { 4 }
    sodium_content_uom { "mmol/L" }
    description { nil }
    deleted_at { nil }
  end
end
