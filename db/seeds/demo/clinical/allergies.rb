module Renalware
  Rails.benchmark "Adding Allergies for Roger RABBIT" do
    patient = Patient.find_by(family_name: "RABBIT", given_name: "Roger")
    patient = Clinical.cast_patient(patient)
    user = Renalware::User.last

    service = Renalware::Clinical::CreateAllergy.new(patient, user)

    service.call(description: "Carrots", recorded_at: 6.months.ago)
    service.call(description: "Penicillin", recorded_at: 1.month.ago)
  end
end
