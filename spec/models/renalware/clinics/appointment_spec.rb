describe Renalware::Clinics::Appointment do
  it_behaves_like "an Accountable model"
  it :aggregate_failures do
    is_expected.to belong_to(:patient).touch(true)
    is_expected.to validate_presence_of(:starts_at)
    is_expected.to validate_presence_of(:patient_id)
    is_expected.to validate_presence_of(:clinic_id)
  end
end
