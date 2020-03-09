# frozen_string_literal: true

FactoryBot.define do
  factory :drug_supplier, class: "Renalware::Drugs::Supplier" do
    name { "Generic" }
  end
end
