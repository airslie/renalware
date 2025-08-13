FactoryBot.define do
  factory :homecare_form, class: "Renalware::Drugs::HomecareForm" do
    supplier factory: %i(drug_supplier)
    drug_type
    form_name { "generic" }
    form_version { "1" }
    prescription_durations { [1, 3, 6] }
    prescription_duration_default { 3 }
    prescription_duration_unit { "month" }
  end
end
