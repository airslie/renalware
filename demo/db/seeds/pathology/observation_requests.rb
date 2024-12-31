def create_observation(patient, request_description)
  pathology_patient = Renalware::Pathology.cast_patient(patient)

  msg = "Adding observations for #{patient.full_name} " \
        "with request description code: #{request_description.code}"

  Rails.benchmark msg do
    request = pathology_patient.observation_requests.create!(
      description: request_description,
      requestor_order_number: rand(100000),
      requested_at: Time.zone.now,
      requestor_name: "Dr Stanley Fan"
    )

    request.observations.create!(
      description: request_description.required_observation_description,
      result: rand(120),
      observed_at: request.requested_at - 9.hours
    )
  end
end

module Renalware
  patient_ids = Clinics::Appointment.distinct.pluck(:patient_id)
  patients = Patient.where(id: patient_ids)
  request_description_ids =
    Pathology::Requests::GlobalRuleSet.distinct.pluck(:request_description_id)
  request_descriptions =
    Pathology::RequestDescription.where(id: request_description_ids)
      .shuffle

  patients.each_with_index do |patient, i|
    request_description = request_descriptions[i % request_descriptions.length - 1]
    next if request_description.required_observation_description.blank?

    create_observation(patient, request_description)
  end
end
