module Renalware
  Rails.benchmark "Adding Allergies for Roger RABBIT" do
    patient = Patient.find_by(family_name: "RABBIT", given_name: "Roger")
    patient = Clinical.cast_patient(patient)
    user = Renalware::User.last

    service = Renalware::Clinical::CreateAllergy.new(patient, user)

    service.call(description: "Carrots", recorded_at: Time.zone.now - 6.months)
    service.call(description: "Penicillin", recorded_at: Time.zone.now - 1.month)
  end
end
