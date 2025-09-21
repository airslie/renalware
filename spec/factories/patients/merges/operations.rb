FactoryBot.define do
  factory :patient_merge_operation, class: "Renalware::Patients::Merges::Operation" do
    merge factory: :patient_merge
    schema_name { "renalware" }
    table_name { "events" }
    merged { true }
  end
end
