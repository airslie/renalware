FactoryGirl.define do
  factory :patient do
    nhs_number "1000124500"
    local_patient_id "Z999990"
    surname "Jones"
    forename "Jack"
    dob "01/01/1988"
    paediatric_patient_indicator "0"
    sex 1
    ethnicity_id 1
  end
end