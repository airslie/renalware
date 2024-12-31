FactoryBot.define do
  factory :hd_dialyser, class: "Renalware::HD::Dialyser" do
    group { "FX" }
    name { "FX80" }
    membrane_surface_area { 234.12 }
    membrane_surface_area_coefficient_k0a { 999.99 }
  end
end
