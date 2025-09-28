FactoryBot.define do
  factory :patient_merge_operation, class: "Renalware::Patients::Merges::Operation" do
    merge factory: :patient_merge
    schema_name { "renalware" }
    table_name { "events" }
    column_name { "patient_id" }
    merged { true }
  end
end
