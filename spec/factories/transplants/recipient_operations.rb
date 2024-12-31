FactoryBot.define do
  factory :transplant_recipient_operation, class: "Renalware::Transplants::RecipientOperation" do
    patient factory: %i(transplant_patient)

    performed_on                      { 1.week.ago }
    theatre_case_start_time           { "11:00" }
    donor_kidney_removed_from_ice_at  { 1.week.ago }
    kidney_perfused_with_blood_at     { 1.week.ago }
    operation_type                    { :kidney }
    cold_ischaemic_time               { "00:45" }
    warm_ischaemic_time               { "00:12" }

    hospital_centre
  end
end
