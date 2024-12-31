FactoryBot.define do
  factory :admissions_admission, class: "Renalware::Admissions::Admission" do
    accountable
    patient { association(:patient, by: accountable_actor) }
    admitted_on { Time.zone.today }
    admission_type { :unknown }
    reason_for_admission { "Reason" }
    hospital_ward
    modality_at_admission { patient&.current_modality }
  end
end
