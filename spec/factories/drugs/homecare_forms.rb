# frozen_string_literal: true

FactoryBot.define do
  factory :homecare_form, class: "Renalware::Drugs::HomecareForm" do
    association :supplier, factory: :drug_supplier
    drug_type
    form_name { "form_name" }
    form_version { "form_version" }
    prescription_durations { [1, 3, 6] }
    prescription_duration_default { 3 }
    prescription_duration_unit { "month" }
  end
end
