FactoryBot.define do
  factory :pathology_requests_patient_rule,
          class: "Renalware::Pathology::Requests::PatientRule" do
    lab factory: %i(pathology_lab)
    patient
    test_description { "Test for HepB" }
    sample_number_bottles { 1 }
    sample_type { nil }
    frequency_type { Renalware::Pathology::Requests::Frequency.all_names.sample }
    start_date { nil }
    end_date { nil }
  end
end
