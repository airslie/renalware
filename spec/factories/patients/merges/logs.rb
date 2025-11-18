FactoryBot.define do
  factory :patient_merge_log, class: "Renalware::Patients::Merges::Log" do
    operation factory: :patient_merge_operation
    id_of_updated_record { 1 }
  end
end
