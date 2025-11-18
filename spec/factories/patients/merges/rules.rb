FactoryBot.define do
  factory :patient_merge_rule, class: "Renalware::Patients::Merges::Rule" do
    schema_name { "renalware" }
    table_name { "events" }
    merge { true }
    warning_message { nil }
  end
end
